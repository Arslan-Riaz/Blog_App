import 'package:blog_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAw4HCN4TEn0wGvHKEMtiHh3bR6ZyQfwm4",
        appId: "1:510308463079:android:de49eb596fc1968e154d42",
        messagingSenderId: "510308463079",
        projectId: "blog-app-f29f5",
        storageBucket: "blog-app-f29f5.appspot.com"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: const SplashScreen(),
    );
  }
}

