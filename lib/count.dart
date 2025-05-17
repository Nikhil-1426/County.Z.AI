import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CountPage extends StatefulWidget {
  const CountPage({Key? key}) : super(key: key);

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  int? _objectCount;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _objectCount = null;
      });
    }
  }

  void _resetCount() {
    setState(() {
      _image = null;
      _objectCount = null;
    });
  }

  Future<void> _sendImageToBackend() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://pipe-counting-app.onrender.com/predict'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _image!.path,
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        int count = jsonResponse['pipe_count'];
        String imageHex = jsonResponse['image'];
        List<int> imageBytes = hex.decode(imageHex);

        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(filePath);
        await file.writeAsBytes(imageBytes);

        setState(() {
          _image = XFile(filePath);
          _objectCount = count;
          _isLoading = false;
        });

        imageCache.clear();
        imageCache.clearLiveImages();
      } else {
        print('Error: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Exception: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Counter', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image + Loading
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(_image!.path),
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Center(
                            child: Text('No image selected'),
                          ),
                  ),
                  if (_isLoading)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 10),
                            Text("Processing...", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Icons.image, "Gallery",
                    () => _pickImage(ImageSource.gallery)),
                const SizedBox(width: 16),
                _buildActionButton(Icons.camera_alt, "Camera",
                    () => _pickImage(ImageSource.camera)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Icons.send, "Send",
                    (_image != null && !_isLoading) ? _sendImageToBackend : null,
                    color: Colors.green),
                const SizedBox(width: 16),
                _buildActionButton(Icons.refresh, "Reset",
                    (_image != null && !_isLoading) ? _resetCount : null,
                    color: Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Object Count Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _objectCount != null
                      ? "Objects Detected: $_objectCount"
                      : "No count yet",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback? onTap,
      {Color color = Colors.deepPurple}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: onTap != null ? color : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
