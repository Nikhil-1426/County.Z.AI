import 'package:flutter/material.dart';

class CountPage extends StatefulWidget {
  const CountPage({Key? key}) : super(key: key);

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  int objectCount = 0;

  void _simulateDetection() {
    // Simulate detecting and counting one object
    setState(() {
      objectCount++;
    });
  }

  void _resetCount() {
    setState(() {
      objectCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Object Counter',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 239, 221, 247),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Camera preview placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Camera Preview / Detection View',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            // Object count display
            Text(
              'Objects Detected:',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            Text(
              '$objectCount',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 156, 39, 176),
              ),
            ),
            const SizedBox(height: 16),

            // Reset Button
            ElevatedButton(
              onPressed: _resetCount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 163, 228),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reset Count',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // Simulate detection floating button
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateDetection,
        backgroundColor: const Color.fromARGB(255, 156, 39, 176),
        child: const Icon(Icons.add),
        tooltip: 'Simulate Detection',
      ),
    );
  }
}
