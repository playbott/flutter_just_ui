import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_ui/just_ui.dart';

Widget buildTestableWidget(Widget child) {
  return MaterialApp(theme: JustTheme.light(), home: Scaffold(body: child));
}

void main() {
  group('JustTextField within JustForm', () {
    late JustFormController controller;

    setUp(() {
      controller = JustFormController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders correctly and allows input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: JustTextField(
              id: 'email',
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(JustTextField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      await tester.enterText(find.byType(JustTextField), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      // Value is not saved yet, just in the text field's controller
      expect(controller.getSavedValues()['email'], isNull);
    });

    testWidgets('validates using controller.validateAll() - required', (
      WidgetTester tester,
    ) async {
      const String requiredError = 'Email cannot be empty';

      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: Column(
              children: [
                JustTextField(
                  id: 'email',
                  validators: [
                    RequiredValidator(customErrorMessage: requiredError),
                  ],
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
        ),
      );

      // Try validating initially (should fail)
      expect(controller.validateAll(), isFalse);
      await tester.pumpAndSettle();

      expect(find.text(requiredError), findsOneWidget);
      expect(controller.fieldValidatiionInfo['email']!.errors, isNotEmpty);
      expect(
        controller.fieldValidatiionInfo['email']!.errors.first.message,
        requiredError,
      );

      // Enter text and validate again (should pass)
      await tester.enterText(find.byType(JustTextField), 'test@example.com');
      await tester.pump();

      expect(controller.validateAll(), isTrue);
      await tester.pumpAndSettle();

      expect(find.text(requiredError), findsNothing);
      expect(controller.fieldValidatiionInfo['email'], isNull);
    });

    testWidgets('validates using controller.validateAll() - min/max length', (
      WidgetTester tester,
    ) async {
      const String minError = 'Min 6 chars';
      const String maxError = 'Max 8 chars';

      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: Column(
              children: [
                JustTextField(
                  id: 'password',
                  validators: [
                    MinLengthValidator(6, customErrorMessage: minError),
                    MaxLengthValidator(8, customErrorMessage: maxError),
                  ],
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test min length
      await tester.enterText(find.byType(JustTextField), '12345');
      await tester.pump();
      expect(controller.validateAll(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsOneWidget);
      expect(find.text(maxError), findsNothing);
      expect(
        controller.fieldValidatiionInfo['password']?.errors.first.message,
        minError,
      );

      // Test max length
      await tester.enterText(find.byType(JustTextField), '123456789');
      await tester.pump();
      expect(controller.validateAll(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing);
      expect(find.text(maxError), findsOneWidget);
      expect(
        controller.fieldValidatiionInfo['password']?.errors.first.message,
        maxError,
      );

      // Test valid length
      await tester.enterText(find.byType(JustTextField), '123456');
      await tester.pump();
      expect(controller.validateAll(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing);
      expect(find.text(maxError), findsNothing);
      expect(controller.fieldValidatiionInfo['password'], isNull);

      await tester.enterText(find.byType(JustTextField), '12345678');
      await tester.pump();
      expect(controller.validateAll(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text(minError), findsNothing);
      expect(find.text(maxError), findsNothing);
      expect(controller.fieldValidatiionInfo['password'], isNull);
    });

    testWidgets('saves value using controller.saveAll() and getValue()', (
      WidgetTester tester,
    ) async {
      String? onSavedValue;

      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: JustTextField(
              id: 'username',
              initialValue: 'tester',
              onSaved: (value) => onSavedValue = value,
            ),
          ),
        ),
      );

      // Check initial value is NOT saved yet
      expect(controller.getSavedValues()['username'], isNull);
      expect(find.text('tester'), findsOneWidget);

      // Change value
      await tester.enterText(find.byType(JustTextField), 'new_tester');
      await tester.pump();

      // Save the form
      controller.saveAll();
      await tester.pump();

      // Verify saved value via controller's saved map and onSaved callback
      expect(controller.getSavedValues()['username'], 'new_tester');
      expect(onSavedValue, 'new_tester');

      // You can also check the current value if needed, but distinguish it from the saved value
      expect(controller.getValue<String>('username'), 'new_tester');
    });

    testWidgets('resets value using controller.resetAll()', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: JustTextField(id: 'comment', initialValue: 'Keep this'),
          ),
        ),
      );

      // Enter different text
      await tester.enterText(find.byType(JustTextField), 'Temporary comment');
      await tester.pump();
      expect(find.text('Temporary comment'), findsOneWidget);

      // Save it to make sure reset clears saved value too
      controller.saveAll();
      expect(controller.getValue<String>('comment'), 'Temporary comment');

      // Reset the form
      controller.resetAll();
      await tester.pumpAndSettle();

      // Should revert to initialValue in display
      expect(find.text('Keep this'), findsOneWidget);
      expect(find.text('Temporary comment'), findsNothing);

      // Check controller's internal value (should be reset)
      // Depending on implementation, reset might clear saved value or revert to initial
      // Let's assume it clears the *saved* value and resets field to initial
      expect(controller.getSavedValues()['comment'], isNull);

      // Check the actual text field controller's CURRENT value
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Keep this');
    });

    testWidgets('updates controller errors reactively', (
      WidgetTester tester,
    ) async {
      const String requiredError = 'Cannot be blank';
      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: Column(
              children: [
                JustTextField(
                  id: 'reactive_field',
                  validators: [
                    RequiredValidator(customErrorMessage: requiredError),
                  ],
                  decoration: const InputDecoration(labelText: 'Reactive'),
                ),

                ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final info =
                        controller.fieldValidatiionInfo['reactive_field'];
                    if (info != null && info.errors.isNotEmpty) {
                      return Text(
                        'Error: ${info.errors.first.message}',
                        key: const Key('error_display'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Initially no error displayed
      expect(find.byKey(const Key('error_display')), findsNothing);

      // Trigger validation
      controller.validateAll();
      await tester.pumpAndSettle();

      // Error should now be displayed via ListenableBuilder
      expect(find.byKey(const Key('error_display')), findsOneWidget);
      expect(find.text('Error: $requiredError'), findsOneWidget);

      // Fix the input
      await tester.enterText(find.byType(JustTextField), 'Valid input');
      await tester.pump();
      controller.validateAll(); // Re-validate
      await tester.pumpAndSettle();

      // Error should disappear
      expect(find.byKey(const Key('error_display')), findsNothing);
    });

    testWidgets('handles obscureText property within JustForm', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          JustForm(
            controller: controller,
            child: JustTextField(id: 'password_jf', obscureText: true),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });
}
