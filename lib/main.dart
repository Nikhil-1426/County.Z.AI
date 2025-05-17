import 'package:flutter/material.dart';
import 'package:pipe_counting_app/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pipe_counting_app/info.dart'; // Fixed import statement


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pipe Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoadingScreen(),
      routes: {
        '/info': (context) => const InfoPage(),
      }
    );
  }
}
