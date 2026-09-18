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

  testWidgets('shows greeting message through native handler after valid input', (tester) async {
    String? capturedTitle;
    String? capturedMessage;

    await tester.pumpWidget(
      MyApp(
        nativeMessageBoxHandler: (title, message) async {
          capturedTitle = title;
          capturedMessage = message;
          return true;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Riko');
    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(capturedTitle, 'Registrasi');
    expect(capturedMessage, 'Hallo Riko');
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('shows snackbar fallback outside Windows', (tester) async {
    await tester.pumpWidget(
      MyApp(
        nativeMessageBoxHandler: (_, __) async => false,
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Riko');
    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(find.text('Registrasi: Hallo Riko'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('uses default fallback path outside Windows', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField), 'Riko');
    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(find.text('Registrasi: Hallo Riko'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('falls back to snackbar when native handler throws', (tester) async {
    final previousOnError = FlutterError.onError;
    FlutterErrorDetails? reportedError;

    FlutterError.onError = (details) {
      reportedError = details;
    };
    addTearDown(() {
      FlutterError.onError = previousOnError;
    });

    await tester.pumpWidget(
      MyApp(
        nativeMessageBoxHandler: (_, __) async {
          throw Exception('native message box failed');
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Riko');
    await tester.tap(find.widgetWithText(FilledButton, 'Registrasi'));
    await tester.pumpAndSettle();

    expect(find.text('Registrasi: Hallo Riko'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      reportedError?.exceptionAsString(),
      contains('native message box failed'),
    );
  });
}
