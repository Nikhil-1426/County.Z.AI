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
        image_url = "https://www.google.com/imgres?q=success%20image%20tick%20image&imgurl=https%3A%2F%2Fcdn2.iconfinder.com%2Fdata%2Ficons%2Fgreenline%2F512%2Fcheck-512.png&imgrefurl=https%3A%2F%2Fwww.iconfinder.com%2Ficons%2F1930264%2Fcheck_complete_done_green_success_valid_icon&docid=qiUH_zztRe7V2M&tbnid=teuprMWjCcjRLM&vet=12ahUKEwiO6-3psK6LAxXEVWwGHVdvJPUQM3oECBUQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwiO6-3psK6LAxXEVWwGHVdvJPUQM3oECBUQAA"
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
