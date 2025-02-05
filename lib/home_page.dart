import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  int? _pipeCount;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _pipeCount = null;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _pipeCount = null;
    });
  }

  void _sendImageToBackend() {
    // TODO: Implement sending image to Flask
    print("Sending image to backend: ${_image?.path}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pipe Counter", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.05), // Top spacing

                    // Dynamic Image Display
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.4, // Adapts dynamically
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(_image!.path),
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: const Color.fromARGB(255, 97, 91, 91),
                              ),
                            ),
                    ),
                    SizedBox(height: 15),

                    // Send & Remove Buttons (Properly Centered & Same Size)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFixedSizeButton(
                          icon: Icons.send,
                          text: "Send",
                          onTap: _image != null ? _sendImageToBackend : null,
                          color: Colors.green,
                        ),
                        SizedBox(width: 20),
                        _buildFixedSizeButton(
                          icon: Icons.delete,
                          text: "Remove",
                          onTap: _image != null ? _removeImage : null,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 25),

                    // Gallery & Camera Options (Properly Centered)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLargeButton(
                          icon: Icons.image,
                          text: "Gallery",
                          onTap: () => _pickImage(ImageSource.gallery),
                        ),
                        SizedBox(width: 20),
                        _buildLargeButton(
                          icon: Icons.camera_alt,
                          text: "Camera",
                          onTap: () => _pickImage(ImageSource.camera),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),

                    // Pipe Count Display Box (Centered)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _pipeCount != null ? "Pipes Detected: $_pipeCount" : "No pipe count available",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 97, 91, 91)),
                        ),
                      ),
                    ),

                    SizedBox(height: constraints.maxHeight * 0.05), // Bottom spacing
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Fixed Size Buttons for Send & Remove
  Widget _buildFixedSizeButton({required IconData icon, required String text, required VoidCallback? onTap, Color color = Colors.blueAccent}) {
    return SizedBox(
      width: 120, // Ensuring both buttons are the same width
      height: 40, // Same height
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: const Color.fromARGB(255, 97, 91, 91)),
        label: Text(text, style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 97, 91, 91))),
        style: ElevatedButton.styleFrom(
          backgroundColor: onTap != null ? color : Colors.grey[400], // Disabled color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Large Buttons for Gallery & Camera
  Widget _buildLargeButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 35, color: Colors.white),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
