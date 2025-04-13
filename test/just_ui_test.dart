import 'package:flutter_test/flutter_test.dart';
import 'package:just_ui/just_ui_components.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('JustTextField shows label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: JustTextField(label: 'JustTextField widget test')),
      ),
    );
    expect(find.text('JustTextField widget test'), findsOneWidget);
  });
}
