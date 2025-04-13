import 'package:flutter/material.dart';

/// A simple form with a submit button.
class JustForm extends StatefulWidget {
  final List<Widget> fields;
  final void Function(Map<String, dynamic>) onSubmit;
  final String submitButtonText;

  const JustForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.submitButtonText = 'Submit',
  });

  @override
  JustFormState createState() => JustFormState();
}

class JustFormState extends State<JustForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...widget.fields,
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit({});
              }
            },
            child: Text(widget.submitButtonText),
          ),
        ],
      ),
    );
  }
}
