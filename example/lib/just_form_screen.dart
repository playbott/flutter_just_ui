import 'package:flutter/material.dart';
import 'package:just_ui/just_ui.dart';

class JustFormExampleScreen extends StatefulWidget {
  const JustFormExampleScreen({super.key});

  @override
  State<JustFormExampleScreen> createState() => _JustFormExampleScreenState();
}

class _JustFormExampleScreenState extends State<JustFormExampleScreen> {
  late JustFormController _justFormController;

  @override
  void initState() {
    _justFormController = JustFormController();
    super.initState();
  }

  @override
  void dispose() {
    _justFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'JustForm Example',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Uses JustTextField with JustForm, controller, id, and JustValidator.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        JustForm(
          controller: _justFormController,
          child: Column(
            children: [
              JustTextField(
                id: 'username',
                decoration: const InputDecoration(
                  labelText: 'User name',
                  hintText: 'Enter user name',
                ),
                validators: [RequiredValidator(), MinLengthValidator(3)],
              ),
              const SizedBox(height: 12),
              JustTextField(
                id: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'your.email@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validators: [RequiredValidator(), EmailValidator()],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_justFormController.validateAll()) {
                    _justFormController.saveAll();
                    final values = _justFormController.getSavedValues();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('JustForm sent! Values: $values')),
                    );
                  }
                },
                child: const Text('Send JustForm'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  _justFormController.resetAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('JustForm has been reset!')),
                  );
                },
                child: const Text('Reset JustForm'),
              ),

              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: _justFormController,
                builder: (context, child) {
                  if (!_justFormController.hasErrors) {
                    return const SizedBox.shrink();
                  }

                  final List<Widget> errorWidgets = [];
                  _justFormController.fieldValidatiionInfo.forEach((
                    fieldId,
                    errorList,
                  ) {
                    errorWidgets.add(
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Field "${errorList.label}":',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                    for (var error in errorList.errors) {
                      errorWidgets.add(
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '- ${error.message}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }
                  });

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red.shade50,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Errors:',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...errorWidgets,
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
