import 'package:belajar_crud_rirebase/firebase_options.dart';
import 'package:belajar_crud_rirebase/pages/home_page.dart';
// import 'package:belajar_crud_rirebase/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app with DevicePreview in debug mode
  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview only in debug mode
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // Use inherited media query for DevicePreview
      locale: DevicePreview.locale(context), // Set locale for DevicePreview
      builder: DevicePreview.appBuilder, // Apply DevicePreview's app builder
      debugShowCheckedModeBanner: false, // Hide debug banner
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      home: HomePage(), // Home page
    );
  }
}
