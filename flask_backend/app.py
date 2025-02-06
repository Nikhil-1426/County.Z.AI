from flask import Flask, request, send_file
from PIL import Image, ImageDraw, ImageFont
import io
import os
import random

app = Flask(__name__)

# Function to process image (draws text on image for now)
def process_image(image_file):
    # Open the image
    image = Image.open(image_file)

    # Draw text on the image
    draw = ImageDraw.Draw(image)
    text = f"Pipes Detected: {random.randint(1, 100)}"
    font = ImageFont.load_default()
    draw.text((10, 10), text, fill="white", font=font)

    # Convert image to byte array
    img_byte_arr = io.BytesIO()
    image.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)

    return img_byte_arr  # Return processed image as bytes

@app.route('/')
def home():
    return "Hello, world!"

@app.route('/upload', methods=['POST'])
def upload_image():
    # Check if the image is provided
    if 'file' not in request.files:
        return "No file part", 400

    file = request.files['file']
    
    if file.filename == '':
        return "No selected file", 400

    try:
        # Process the image
        processed_image = process_image(file)

        # Return only the processed image
        return send_file(processed_image, mimetype='image/png')

    except Exception as e:
        return f"Error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)))
