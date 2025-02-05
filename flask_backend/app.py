from flask import Flask, request, jsonify, send_file
from PIL import Image, ImageDraw, ImageFont
import io
import os
import random

app = Flask(__name__)

# This is a dummy function that processes the image
def process_image(image_file):
    # Open the image
    image = Image.open(image_file)
    
    # Process the image (for demonstration purposes, let's draw some text on it)
    draw = ImageDraw.Draw(image)
    text = f"Processed Image - {random.randint(1, 100)}"
    font = ImageFont.load_default()
    draw.text((10, 10), text, fill="white", font=font)

    # Convert the image to bytes and return
    img_byte_arr = io.BytesIO()
    image.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)

    return img_byte_arr, text

@app.route('/')
def home():
    return "Hello, world!"

@app.route('/upload', methods=['POST'])
def upload_image():
    # Check if the image is provided
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # Process the image using the process_image function
    img_byte_arr, text = process_image(file)

    # Return the processed image and text
    return jsonify({"message": text}), send_file(img_byte_arr, mimetype='image/png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)))

