import 'dart:convert';  // ✅ Needed for jsonDecode
import 'package:convert/convert.dart';  // ✅ Needed for hex decoding
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  int? _pipeCount;
  bool _isLoading = false; // Added loading state

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

  Future<void> _sendImageToBackend() async {
    if (_image == null) return;

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://pipe-counting-app.onrender.com/predict')
      , // ✅ Correct endpoint
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file', // ✅ Must match Flask request.files['file']
      _image!.path,
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        int detectedPipes = jsonResponse['pipe_count']; // ✅ Get pipe count
        String imageHex = jsonResponse['image']; // ✅ Get hex image

        // Convert hex string to bytes
        List<int> imageBytes = hex.decode(imageHex);

        // Save received image to temporary file
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/processed_image_${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(filePath);
        await file.writeAsBytes(imageBytes);

        setState(() {
          _image = XFile(filePath);
          _pipeCount = detectedPipes; // ✅ Use the temporary file path
          _isLoading = false; // Set loading state to false
        });

        // ✅ Force Flutter to reload the image
        imageCache.clear();
        imageCache.clearLiveImages();
      } else {
        print('❌ Failed to process image: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Set loading state to false even on error
        });
      }
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _isLoading = false; // Set loading state to false even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Pipe Counter", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30), // Space from the top bar

                  // Dynamic Image Display with Loading Overlay
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight:
                              constraints.maxHeight * 0.4, // Adapts dynamically
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
                                  color: Colors.grey[700],
                                ),
                              ),
                      ),
                      // Loading Overlay
                      if (_isLoading)
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxHeight:
                                constraints.maxHeight * 0.4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Processing Image...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Send & Remove Buttons (Properly Centered & Same Size)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFixedSizeButton(
                        icon: Icons.send,
                        text: "Send",
                        onTap: (_image != null && !_isLoading) ? _sendImageToBackend : null,
                        color: Colors.green,
                      ),
                      SizedBox(width: 20),
                      _buildFixedSizeButton(
                        icon: Icons.delete,
                        text: "Remove",
                        onTap: (_image != null && !_isLoading) ? _removeImage : null,
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
                        isDisabled: _isLoading,
                      ),
                      SizedBox(width: 20),
                      _buildLargeButton(
                        icon: Icons.camera_alt,
                        text: "Camera",
                        onTap: () => _pickImage(ImageSource.camera),
                        isDisabled: _isLoading,
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
                        _pipeCount != null
                            ? "Pipes Detected: $_pipeCount"
                            : "No pipe count available",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 97, 91, 91)),
                      ),
                    ),
                  ),

                  SizedBox(height: 20), // Space at the bottom
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Fixed Size Buttons for Send & Remove
  Widget _buildFixedSizeButton(
      {required IconData icon,
      required String text,
      required VoidCallback? onTap,
      Color color = Colors.blueAccent}) {
    return SizedBox(
      width: 120, // Ensuring both buttons are the same width
      height: 40, // Same height
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon:
            Icon(icon, size: 18, color: const Color.fromARGB(255, 97, 91, 91)),
        label: Text(text,
            style: TextStyle(
                fontSize: 14, color: const Color.fromARGB(255, 97, 91, 91))),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              onTap != null ? color : Colors.grey[400], // Disabled color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Large Buttons for Gallery & Camera
  Widget _buildLargeButton(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      bool isDisabled = false}) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 140,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[400] : Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isDisabled ? Colors.grey : Colors.blueAccent).withOpacity(0.3),
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}