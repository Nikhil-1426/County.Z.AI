import cv2
import numpy as np
import io
import os
import requests
from flask import Flask, request, send_file
from ultralytics import YOLO
from flask_cors import CORS
from PIL import Image

# Initialize Flask app
app = Flask(__name__)
CORS(app)

MODEL_URL = "https://drive.google.com/uc?export=download&id=1a5A3Db34TmV2CyH9g9FfvxH_upkaDqoa"  # Direct Download Link
MODEL_PATH = "best.pt"

def download_model():
    """Download YOLO model from Google Drive (if not present)."""
    if not os.path.exists(MODEL_PATH):
        print("Downloading model...")
        session = requests.Session()
        response = session.get(MODEL_URL, stream=True)
        with open(MODEL_PATH, "wb") as f:
            for chunk in response.iter_content(1024):
                f.write(chunk)
        print("Download complete!")

# Ensure model is downloaded before initializing YOLO
download_model()
model = YOLO(MODEL_PATH)

def read_image(file_storage):
    """Convert incoming file storage object to OpenCV image format"""
    file_bytes = np.frombuffer(file_storage.read(), np.uint8)
    image = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)
    return image

@app.route('/')
def home():
    return "Hello, world!"

@app.route('/predict', methods=['POST'])
def predict():
    """Process image and return object detection results along with processed image"""
    if 'file' not in request.files:
        return "No file provided.", 400
    
    file = request.files['file']
    image = read_image(file)
    
    # Run inference
    results = model.predict(image, conf=0.5, iou=0.3)
    pipe_count = len(results[0].boxes)

    # Draw bounding boxes on the image
    for result in results:
        for box in result.boxes:
            xyxy = box.xyxy.cpu().numpy().tolist()[0]  # Bounding box coordinates
            conf = box.conf.cpu().numpy().tolist()[0]  # Confidence score
            cls = int(box.cls.cpu().numpy().tolist()[0])  # Class index
            
            # Draw bounding box and label on the image
            x1, y1, x2, y2 = map(int, xyxy)
            cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)  # Green box
            cv2.putText(image, f"Pipe {cls}", (x1, y1 - 10), 
            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    # Convert image to PNG format for response
    _, img_encoded = cv2.imencode('.png', image)
    img_bytes = io.BytesIO(img_encoded.tobytes())

    return {
        "pipe_count": pipe_count,
        "image": img_bytes.getvalue().hex()  # Convert to hex string for sending
    }
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
