<center>
<img src="https://readme-typing-svg.herokuapp.com/?font=Times+New+Roman&weight=500&size=30&pause=1000&width=435&lines=Welcome+to+County.Z+AI!" />
</center>


This is a **Flutter** application that detects and counts pipes in an image using a **Flask** backend with a **YOLOv8** model. The app allows users to upload an image, processes it on the backend, and returns the image with detected pipes along with the pipe count.

---

## 📌 Features

- Upload an image from the gallery or camera.
- Sends the image to a **Flask** backend for pipe detection.
- Receives a processed image with pipes mapped.
- Displays the **number of detected pipes**.
- Fast processing with **YOLOv8**.

---

## 🚀 Getting Started

### Setup (For running it locally)

#### Prerequisites:
- Python 3.x
- Flask
- OpenCV
- YOLOv8
- NumPy
- PIL
- Flask-CORS
- Requests

#### Make sure to change the render website link to the URL on which Flask is runnning locally.

#### Installation:
```sh
git clone https://github.com/Nikhil-1426/Pipe_Counting_App.git
```
```sh
cd Pipe_Counting_App/flask_backend
pip install -r requirements.txt
python app.py
```
```sh
cd ..
flutter run
```

### Setup (For running it using Render)

#### Prerequisites:
- Make sure that the render server is live ( https://pipe-counting-app.onrender.com )

#### Installation:
```sh
git clone https://github.com/Nikhil-1426/Pipe_Counting_App.git
cd Pipe_Counting_App
flutter run
```

# Screenshots
<pre>
<img src = "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/signup.jpg" width = "200">  <img src = "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/Homepage.jpg" width = "200">  <img src = "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/count_page1.jpg" width = "200">  <img src= "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/count_page2.jpg" width = "200"> <img src= "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/historypage.jpg" width = "200"> <img src= "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/profilepage.jpg" width = "200"> <img src= "https://github.com/Nikhil-1426/Pipe_Counting_App/blob/main/assets/about page.jpg" width = "200">
</pre>

### TechStack

1. **Flutter / Dart:**
   - Used for building a seamless, cross-platform mobile application with a user-friendly interface designed for global travellers.
2. **Flask API:**
   - Handles backend processes for trip analysis, health profiling, and REST API calls, ensuring seamless communication between the app and AI services.
3. **Render:**
   - Used for deploying the Flask backend, providing a scalable and reliable cloud platform to host the API, ensuring seamless access and performance for users worldwide.


## Developed by Ziga Infotech
