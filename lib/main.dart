import 'package:flutter/material.dart';
import 'package:total_tally/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    //20240414 add global lang version
    
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}