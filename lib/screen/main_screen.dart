import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }

  void func() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('라디오 버튼 선택:'),
            Row(
              children: [
                Text('Option 1'),
                Text('Option 2'),
              ],
            ),
            SizedBox(height: 20),
            Text('텍스트 입력:'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: func,
                child: Text('전송'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
