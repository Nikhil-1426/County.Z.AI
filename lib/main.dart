import 'package:flutter/material.dart';
import 'package:pipe_counting_app/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pipe_counting_app/info.dart';
import 'history.dart';
import 'home_page.dart'; // Assuming your HomePage is in home.dart
import 'auth.dart';
import 'count.dart'; // Fixed import statement

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
          '/count': (context) => const CountPage(),
          '/history': (context) => const HistoryPage(),
          '/auth': (context) =>
              const AuthScreen(), // Placeholder for history page
        });
  }
}
