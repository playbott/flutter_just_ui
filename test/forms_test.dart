import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_ui/just_ui.dart';

void main() {
  testWidgets('JustForm validates fields and submits', (tester) async {
    var submitted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JustForm(
            fields: [
              JustTextField(
                label: 'Email',
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
                fieldKey: const Key('email_field'),
              ),
            ],
            onSubmit: (_) => submitted = true,
            submitButtonText: 'Submit',
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    expect(submitted, false);

    await tester.enterText(
      find.byKey(const Key('email_field')),
      'test@example.com',
    );
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(submitted, true);
  });
}
