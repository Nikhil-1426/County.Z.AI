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
      Uri.parse('http://192.168.1.103:5000/predict'),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9D78F9),
              Color(0xFF78BDF9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Back arrow
              Row(
                children: [
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              // Header with icon
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_enhance,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Object Counter",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "AI-powered object detection and counting",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(1),
                ),
              ),
              const SizedBox(height: 19),
              // White card container
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Image Display Area
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _image != null
                                    ? Image.file(
                                        File(_image!.path),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_outlined,
                                            size: 64,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No image selected',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Choose from gallery or camera',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
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
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "Processing...",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.image_outlined,
                              text: "Gallery",
                              onTap: () => _pickImage(ImageSource.gallery),
                              isEnabled: !_isLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.camera_alt_outlined,
                              text: "Camera",
                              onTap: () => _pickImage(ImageSource.camera),
                              isEnabled: !_isLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.send_outlined,
                              text: "Analyze",
                              onTap: (_image != null && !_isLoading) ? _sendImageToBackend : null,
                              isEnabled: _image != null && !_isLoading,
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.refresh_outlined,
                              text: "Reset",
                              onTap: (_image != null && !_isLoading) ? _resetCount : null,
                              isEnabled: _image != null && !_isLoading,
                              isDestructive: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Result Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: _objectCount != null
                              ? const LinearGradient(
                                  colors:  [Color(0xFF9D78F9), Color(0xFF78BDF9)],
                                )
                              : null,
                          color: _objectCount == null ? Colors.grey.shade50 : null,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _objectCount != null ? Colors.transparent : Colors.grey.shade200,
                          ),
                          boxShadow: _objectCount != null
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF9D78F9).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _objectCount != null ? Icons.analytics_outlined : Icons.search_outlined,
                              size: 32,
                              color: _objectCount != null ? Colors.white : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _objectCount != null ? "Pipe Count" : "Pipe Count",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _objectCount != null ? Colors.white.withOpacity(0.9) : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _objectCount != null ? "$_objectCount" : "No count yet",
                              style: TextStyle(
                                fontSize: _objectCount != null ? 32 : 16,
                                fontWeight: _objectCount != null ? FontWeight.bold : FontWeight.w500,
                                color: _objectCount != null ? Colors.white : Colors.grey.shade400,
                                letterSpacing: _objectCount != null ? 1.2 : 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback? onTap,
    required bool isEnabled,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color getButtonColor() {
      if (!isEnabled) return Colors.grey.shade300;
      if (isPrimary) return const Color(0xFF9D78F9);
      if (isDestructive) return Colors.red.shade400;
      return Colors.grey.shade100;
    }

    Color getTextColor() {
      if (!isEnabled) return Colors.grey.shade500;
      if (isPrimary || isDestructive) return Colors.white;
      return Colors.grey.shade700;
    }

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: isPrimary && isEnabled
            ? null
            : getButtonColor(),
        gradient: isPrimary && isEnabled
            ? const LinearGradient(
                colors: [Color(0xFF9D78F9), Color(0xFF78BDF9)],
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: !isPrimary && !isDestructive
            ? Border.all(color: Colors.grey.shade300)
            : null,
        boxShadow: isPrimary && isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF9D78F9).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : isDestructive && isEnabled
                ? [
                    BoxShadow(
                      color: Colors.red.shade400.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: getTextColor(),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: getTextColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}