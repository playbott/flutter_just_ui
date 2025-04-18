import 'package:flutter/material.dart';
import 'package:just_ui/just_ui.dart';
import 'package:just_ui_example/just_form_screen.dart';
import 'package:just_ui_example/standard_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just UI Demo',
      theme: JustTheme.light(),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Just UI Form Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormExampleScreen(),
            SizedBox(height: 24),
            JustFormExampleScreen(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
