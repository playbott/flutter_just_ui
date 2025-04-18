import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_ui/just_ui.dart';

Widget buildTestableWidget(Widget child) {
  return MaterialApp(theme: JustTheme.light(), home: Scaffold(body: child));
}

void main() {
  group('JustTextField within standard Flutter Form', () {
    testWidgets('renders correctly with decoration', (
      WidgetTester tester,
    ) async {
      const Key textFieldKey = Key('myTextField');
      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            child: JustTextField(
              key: textFieldKey,
              id: 'test',
              decoration: const InputDecoration(
                labelText: 'Test Label',
                hintText: 'Test Hint',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(textFieldKey), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('allows text input', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      String? savedValue;

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: JustTextField(
              id: 'test_input',
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(JustTextField), 'Hello World');
      await tester.pump();

      expect(find.text('Hello World'), findsOneWidget);

      // Verify saving
      formKey.currentState!.save();
      expect(savedValue, 'Hello World');
    });

    testWidgets('validates using FormState.validate() - required', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      const String requiredError = 'This field is required';

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: Column(
              // Column needed for potential error text space
              children: [
                JustTextField(
                  id: 'required_field',
                  validators: [
                    RequiredValidator(customErrorMessage: requiredError),
                  ],
                  decoration: const InputDecoration(labelText: 'Required'),
                ),
              ],
            ),
          ),
        ),
      );

      // Try validating initially (should fail)
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle(); // Allow time for error text to appear

      expect(find.text(requiredError), findsOneWidget);

      // Enter text and validate again (should pass)
      await tester.enterText(find.byType(JustTextField), 'Some text');
      await tester.pump();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle(); // Allow time for error text to disappear

      expect(find.text(requiredError), findsNothing);
    });

    testWidgets('validates using FormState.validate() - min/max length', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      const String minError = 'Min 3 chars';
      const String maxError = 'Max 5 chars';

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: Column(
              children: [
                JustTextField(
                  id: 'length_field',
                  validators: [
                    MinLengthValidator(3, customErrorMessage: minError),
                    MaxLengthValidator(5, customErrorMessage: maxError),
                  ],
                  decoration: const InputDecoration(labelText: 'Length'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test min length
      await tester.enterText(find.byType(JustTextField), 'ab');
      await tester.pump();
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsOneWidget);
      expect(find.text(maxError), findsNothing); // Max shouldn't trigger yet

      // Test max length
      await tester.enterText(find.byType(JustTextField), 'abcdef');
      await tester.pump();
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing); // Min shouldn't trigger
      expect(find.text(maxError), findsOneWidget);

      // Test valid length
      await tester.enterText(find.byType(JustTextField), 'abc');
      await tester.pump();
      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing);
      expect(find.text(maxError), findsNothing);

      await tester.enterText(find.byType(JustTextField), 'abcde');
      await tester.pump();
      expect(formKey.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing);
      expect(find.text(maxError), findsNothing);
    });

    testWidgets('saves value using FormState.save() and calls onSaved', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      String? onSavedValue;
      final Map<String, dynamic> formValues = {}; // Simulate saving to a map

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: JustTextField(
              id: 'save_field',
              initialValue: 'Initial', // Test initial value if needed
              onSaved: (value) {
                onSavedValue = value;
                formValues['save_field'] =
                    value; // Simulate how Form might save
              },
            ),
          ),
        ),
      );

      // Check initial state
      expect(find.text('Initial'), findsOneWidget);

      // Change value and save
      await tester.enterText(find.byType(JustTextField), 'New Value');
      await tester.pump();

      formKey.currentState!.save();
      await tester.pump(); // Allow save callbacks to run

      expect(onSavedValue, 'New Value');
      expect(formValues['save_field'], 'New Value');
    });

    testWidgets('resets value using FormState.reset()', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: JustTextField(
              id: 'reset_field',
              initialValue: 'Don\'t Reset Me', // Set an initial value
            ),
          ),
        ),
      );

      // Enter different text
      await tester.enterText(find.byType(JustTextField), 'Temporary Text');
      await tester.pump();
      expect(find.text('Temporary Text'), findsOneWidget);

      // Reset the form
      formKey.currentState!.reset();
      await tester.pump();

      // Should revert to initialValue (or empty if no initialValue)
      expect(find.text('Don\'t Reset Me'), findsOneWidget);
      expect(find.text('Temporary Text'), findsNothing);

      // Find the underlying TextField's controller to be absolutely sure
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Don\'t Reset Me');
    });

    testWidgets('handles obscureText property', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Form(child: JustTextField(id: 'password', obscureText: true)),
        ),
      );

      // Find the internal TextField used by JustTextField
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // Enter text and verify it's obscured (though visually hard to confirm in test)
      await tester.enterText(find.byType(JustTextField), 'secret');
      await tester.pump();
      // We can't easily check *if* it's visually obscured,
      // but we know the property is set and text was entered.
      expect(textField.controller?.text, 'secret');
    });
  });
}
