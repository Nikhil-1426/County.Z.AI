import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pipe_counting_app/support.dart';

// Import all actual screens
import 'loading_screen.dart';
import 'auth.dart';
import 'home_page.dart';
import 'count.dart';
import 'history.dart'; // Your actual HistoryPage
import 'info.dart';
import 'profile_page.dart';

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

      // Named routes (no userId needed)
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home_page': (context) => const HomePage(),
        '/count': (context) => const CountPage(),
        '/history': (context) => const HistoryPage(), // <-- correct one
        '/info': (context) => const InfoPage(),
        '/profile': (context) => const ProfilePage(),
        '/support': (context) => const SupportPage(), // Add support page route
      },
    );
  }
}
