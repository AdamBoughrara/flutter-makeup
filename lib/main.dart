import 'package:automated_makeup_robot_software/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:automated_makeup_robot_software/screens/favorites_page.dart';
import 'package:automated_makeup_robot_software/screens/feedback_page.dart';
import 'package:automated_makeup_robot_software/screens/profile_page.dart';
import 'package:automated_makeup_robot_software/screens/home_page.dart';
import 'package:automated_makeup_robot_software/screens/choose_model_page.dart';
import 'package:automated_makeup_robot_software/screens/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/test_diagnosis_page.dart'; // Import the Settings page

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automated Makeup App',
      theme: ThemeData(
        primaryColor: Colors.pink.shade300,
        primarySwatch: Colors.pink,
      ),
      home: AppScreen(),
      routes: {
        '/settings': (context) => SettingsPage(),
        '/testing': (context) => TestDiagnosisPage(),
      },
    );
  }
}
