import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_app/main.dart';

void main() {
  testWidgets('shows validation message when name is empty', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(find.text('Input harus di isi'), findsOneWidget);
  });

  testWidgets('shows greeting message through native handler after valid input', (
    tester,
  ) async {
    String? capturedTitle;
    String? capturedMessage;

    await tester.pumpWidget(
      MyApp(
        messageBoxHandler: (title, message) {
          capturedTitle = title;
          capturedMessage = message;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Riko');
    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(capturedTitle, 'Registrasi');
    expect(capturedMessage, 'Hallo Riko');
  });
}
