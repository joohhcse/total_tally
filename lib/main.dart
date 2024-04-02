import 'package:flutter/material.dart';
import 'package:total_tally/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // const MyApp()
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}