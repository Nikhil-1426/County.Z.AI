# from flask import Flask, request, send_file
# from PIL import Image, ImageDraw, ImageFont
# import io
# import os
# import random
# import requests

# app = Flask(__name__)

# # Function to process image (draws text on image for now)
# def process_image(image_file):
#     try:
#         # Fetch a default success image from the web
#         image_url = "https://raw.githubusercontent.com/Nikhil-1426/Justice.ai/main/src/assets/final_logo.png"
#         response = requests.get(image_url)
        
#         if response.status_code != 200:
#             raise Exception("Failed to fetch success image")

#         # Convert image to byte array
#         img_byte_arr = io.BytesIO(response.content)
#         img_byte_arr.seek(0)

#         return img_byte_arr  # Return the default success image

#     except Exception as e:
#         print(f"Error fetching success image: {e}")
#         return None

# @app.route('/')
# def home():
#     return "Hello, world!"

# @app.route('/upload', methods=['POST'])
# def upload_image():
#     # Check if the image is provided
#     if 'file' not in request.files:
#         return "No file part", 400

#     file = request.files['file']
    
#     if file.filename == '':
#         return "No selected file", 400

#     try:
#         # Process the image
#         processed_image = process_image(file)

#         # Return only the processed image
#         return send_file(processed_image, mimetype='image/png')

#     except Exception as e:
#         return f"Error: {str(e)}", 500

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)))



import cv2
import numpy as np
import io
from flask import Flask, request, jsonify, send_file
from ultralytics import YOLO
from flask_cors import CORS
from PIL import Image

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load YOLO model ONCE (Avoid reloading on every request)
model = YOLO("pipe_counting_app/flask_backend/best.pt")

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
        return jsonify({'error': 'No file provided.'}), 400
    
    file = request.files['file']
    image = read_image(file)
    
    # Run inference
    results = model.predict(image, conf=0.5, iou=0.3)

    predictions = []
    
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

            predictions.append({
                'box': xyxy,
                'confidence': conf,
                'class': cls
            })

    # Convert image to PNG format for response
    _, img_encoded = cv2.imencode('.png', image)
    img_bytes = io.BytesIO(img_encoded.tobytes())

    # Send image along with JSON data
    return send_file(img_bytes, mimetype='image/png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
