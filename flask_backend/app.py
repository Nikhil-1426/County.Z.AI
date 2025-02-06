from flask import Flask, request, send_file
from PIL import Image, ImageDraw, ImageFont
import io
import os
import random
import requests

app = Flask(__name__)

# Function to process image (draws text on image for now)
def process_image(image_file):
    try:
        # Fetch a default success image from the web
        image_url = "https://raw.githubusercontent.com/Nikhil-1426/Justice.ai/main/src/assets/final_logo.png"
        response = requests.get(image_url)
        
        if response.status_code != 200:
            raise Exception("Failed to fetch success image")

        # Convert image to byte array
        img_byte_arr = io.BytesIO(response.content)
        img_byte_arr.seek(0)

        return img_byte_arr  # Return the default success image

    except Exception as e:
        print(f"Error fetching success image: {e}")
        return None

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
