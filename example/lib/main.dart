import 'package:flutter/material.dart';
import 'package:just_ui/just_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: JustTheme.light(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Just UI Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: JustForm(
            fields: [
              JustTextField(
                label: 'Email',
                hint: 'Enter your email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              JustTextField(
                label: 'Password',
                hint: 'Enter your password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
            onSubmit: (data) {
              // Form Submitted
            },
            submitButtonText: 'Sign In',
          ),
        ),
      ),
    );
  }
}
