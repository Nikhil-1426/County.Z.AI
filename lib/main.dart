import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importing all required screens
import 'loading_screen.dart';
import 'auth.dart';
import 'home_page.dart';
import 'count.dart';
import 'history.dart';
import 'info.dart';
class HistoryPage extends StatelessWidget {
  final String userId;

  const HistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use userId here or ignore it if not needed
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Center(child: Text('User ID: $userId')),
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      // Starting screen of the app
      home: const LoadingScreen(),
      
      // Defining named routes
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home_page': (context) => const HomePage(),
        '/count': (context) => const CountPage(),
        '/history': (context) => const HistoryPage(userId: '',),
        '/info': (context) => const InfoPage(),
      },
    );
  }
}
