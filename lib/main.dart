import 'package:flutter/material.dart';
import 'package:internship_main/gallery.dart';
import 'login.dart';
import 'signup.dart';
import "home.dart";
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signup': (context) => SignUp(),
        '/gallery': (context) => Gallery(),
        '/home': (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
      home: LogIn(),
    );
  }
}
