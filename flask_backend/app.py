import cv2
import numpy as np
import io
import os
import requests
import torch
from flask import Flask, request, jsonify
from ultralytics import YOLO
from flask_cors import CORS
from torchvision.ops import nms

app = Flask(__name__)
CORS(app)

MODEL_URL = "https://drive.google.com/uc?export=download&id=12QhVOMkVyR_JweTmf-KydK1s15ZqQn6p"
MODEL_PATH = "best.pt"

def download_model():
    if not os.path.exists(MODEL_PATH):
        print("Downloading model...")
        session = requests.Session()
        response = session.get(MODEL_URL, stream=True)
        with open(MODEL_PATH, "wb") as f:
            for chunk in response.iter_content(1024):
                f.write(chunk)
        print("Download complete!")

download_model()
model = YOLO(MODEL_PATH)

def read_image(file_storage):
    file_bytes = np.frombuffer(file_storage.read(), np.uint8)
    image = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)
    return image

def split_image_into_tiles(image, rows=2, cols=2):
    h, w = image.shape[:2]
    tile_h, tile_w = h // rows, w // cols
    tiles = []
    for r in range(rows):
        for c in range(cols):
            y1 = r * tile_h
            y2 = (r + 1) * tile_h if r < rows - 1 else h
            x1 = c * tile_w
            x2 = (c + 1) * tile_w if c < cols - 1 else w
            tile = image[y1:y2, x1:x2]
            tiles.append((tile, (x1, y1)))
    return tiles

def apply_global_nms(boxes, scores, iou_threshold=0.5):
    boxes_tensor = torch.tensor(boxes, dtype=torch.float32)
    scores_tensor = torch.tensor(scores, dtype=torch.float32)
    keep_indices = nms(boxes_tensor, scores_tensor, iou_threshold)
    return keep_indices.cpu().numpy().tolist()

@app.route('/')
def home():
    return "YOLOv8 Pipe Detection API"

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    image = read_image(file)
    tiles = split_image_into_tiles(image, rows=2, cols=2)
    
    boxes_all = []
    scores_all = []
    classes_all = []
    
    for tile_img, (offset_x, offset_y) in tiles:
        results = model.predict(tile_img, conf=0.5, iou=0.3)
        for result in results:
            for box in result.boxes:
                xyxy = box.xyxy.cpu().numpy()[0]
                conf = float(box.conf.cpu().numpy()[0])
                cls = int(box.cls.cpu().numpy()[0])
                
                # Adjust box to full image coords
                x1 = float(xyxy[0] + offset_x)
                y1 = float(xyxy[1] + offset_y)
                x2 = float(xyxy[2] + offset_x)
                y2 = float(xyxy[3] + offset_y)
                
                boxes_all.append([x1, y1, x2, y2])
                scores_all.append(conf)
                classes_all.append(cls)
    
    if boxes_all:
        keep_indices = apply_global_nms(boxes_all, scores_all, iou_threshold=0.5)
    else:
        keep_indices = []
    
    filtered_boxes = [boxes_all[i] for i in keep_indices]
    filtered_scores = [scores_all[i] for i in keep_indices]
    filtered_classes = [classes_all[i] for i in keep_indices]
    
    pipe_count = len(filtered_boxes)
    
    # Draw filtered boxes
    for box, conf, cls in zip(filtered_boxes, filtered_scores, filtered_classes):
        x1, y1, x2, y2 = map(int, box)
        cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
        cv2.putText(image, f"Pipe {cls} {conf:.2f}", (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
    
    _, img_encoded = cv2.imencode('.png', image)
    img_bytes = io.BytesIO(img_encoded.tobytes())

    return jsonify({
        "pipe_count": pipe_count,
        "image": img_bytes.getvalue().hex()
    })

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=False)