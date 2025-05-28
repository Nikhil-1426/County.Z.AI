import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // If using Firebase Firestore
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  final String userId;

  const HistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<PipeDetectionRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    // Fetch history on init
    _historyFuture = fetchHistory();
  }

  Future<List<PipeDetectionRecord>> fetchHistory() async {
    // Option 1: Fetch from Firestore collection "pipe_detections" filtered by userId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('pipe_detections')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return PipeDetectionRecord(
        pipeCount: data['pipe_count'] ?? 0,
        imageHex: data['image'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList();

    // Option 2: Or fetch from your Flask backend API if you save history there
    // final response = await http.get(Uri.parse('YOUR_BACKEND_API/history?userId=${widget.userId}'));
    // Parse and return list similarly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detection History')),
      body: FutureBuilder<List<PipeDetectionRecord>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final imageBytes = hexToBytes(record.imageHex);
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: imageBytes != null
                      ? Image.memory(imageBytes, width: 80, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text('Pipe Count: ${record.pipeCount}'),
                  subtitle: Text('Detected on: ${record.timestamp}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Uint8List? hexToBytes(String hex) {
    try {
      return Uint8List.fromList(hexDecode(hex));
    } catch (e) {
      return null;
    }
  }

  List<int> hexDecode(String hex) {
    final result = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final byte = hex.substring(i, i + 2);
      result.add(int.parse(byte, radix: 16));
    }
    return result;
  }
}

class PipeDetectionRecord {
  final int pipeCount;
  final String imageHex;
  final DateTime timestamp;

  PipeDetectionRecord({
    required this.pipeCount,
    required this.imageHex,
    required this.timestamp,
  });
}
