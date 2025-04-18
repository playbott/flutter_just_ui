import 'package:flutter/material.dart';
import 'package:just_ui/just_ui.dart';

class FormExampleScreen extends StatefulWidget {
  const FormExampleScreen({super.key});

  @override
  State<FormExampleScreen> createState() => _FormExampleScreenState();
}

class _FormExampleScreenState extends State<FormExampleScreen> {
  final _standardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Standard Flutter Form Example',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Uses JustTextField with standard Form and JustValidator',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Form(
          key: _standardFormKey,
          child: Column(
            children: [
              JustTextField(
                decoration: const InputDecoration(
                  labelText: 'User name',
                  hintText: 'Enter name',
                ),
                validators: [RequiredValidator(), MinLengthValidator(3)],
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 12),
              JustTextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'user.name@mail.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validators: [RequiredValidator(), EmailValidator()],
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_standardFormKey.currentState?.validate() ?? false) {
                    _standardFormKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Standard form sent!')),
                    );
                  }
                },
                child: const Text('Send standard form'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
