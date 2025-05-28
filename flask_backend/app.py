import cv2
import numpy as np
import io
import os
import requests
from flask import Flask, request, jsonify
from ultralytics import YOLO
from flask_cors import CORS
from datetime import datetime
from google.cloud import firestore
import base64

app = Flask(__name__)
CORS(app)

MODEL_URL = "https://drive.google.com/uc?export=download&id=1a5A3Db34TmV2CyH9g9FfvxH_upkaDqoa"
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

# Initialize Firestore client using Application Default Credentials
# Make sure environment variable GOOGLE_APPLICATION_CREDENTIALS is set OR
# you have logged in via `gcloud auth application-default login`
db = firestore.Client()

@app.route('/')
def home():
    return "YOLOv8 Pipe Detection API"

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    user_id = request.form.get('userId', None)
    if user_id is None:
        return jsonify({"error": "userId is required in form data"}), 400

    image = read_image(file)
    tiles = split_image_into_tiles(image, rows=2, cols=2)
    
    total_boxes = []

    for tile_img, (offset_x, offset_y) in tiles:
        results = model.predict(tile_img, conf=0.5, iou=0.3)
        for result in results:
            for box in result.boxes:
                xyxy = box.xyxy.cpu().numpy()[0]
                conf = box.conf.cpu().numpy()[0]
                cls = int(box.cls.cpu().numpy()[0])

                x1 = int(xyxy[0] + offset_x)
                y1 = int(xyxy[1] + offset_y)
                x2 = int(xyxy[2] + offset_x)
                y2 = int(xyxy[3] + offset_y)

                total_boxes.append({
                    "box": (x1, y1, x2, y2),
                    "conf": conf,
                    "cls": cls
                })

    pipe_count = len(total_boxes)

    # Draw boxes on image
    for item in total_boxes:
        x1, y1, x2, y2 = item["box"]
        cls = item["cls"]
        conf = item["conf"]
        cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
        cv2.putText(image, f"Pipe {cls} {conf:.2f}", (x1, y1 - 10), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    _, img_encoded = cv2.imencode('.png', image)
    img_bytes = img_encoded.tobytes()

    # Convert image bytes to hex string for easier JSON serialization
    img_hex = img_bytes.hex()

    # Save detection result to Firestore
    doc_ref = db.collection('pipe_detections').document()
    doc_ref.set({
        "userId": user_id,
        "pipe_count": pipe_count,
        "image": img_hex,
        "timestamp": datetime.utcnow()
    })

    return jsonify({
        "pipe_count": pipe_count,
        "image": img_hex
    })

@app.route('/history', methods=['GET'])
def history():
    user_id = request.args.get('userId', None)
    if user_id is None:
        return jsonify({"error": "userId query param is required"}), 400

    docs = db.collection('pipe_detections')\
             .where('userId', '==', user_id)\
             .order_by('timestamp', direction=firestore.Query.DESCENDING)\
             .stream()

    results = []
    for doc in docs:
        data = doc.to_dict()
        results.append({
            "pipe_count": data.get("pipe_count"),
            "image": data.get("image"),
            "timestamp": data.get("timestamp").isoformat() if data.get("timestamp") else None
        })

    return jsonify(results)


if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
