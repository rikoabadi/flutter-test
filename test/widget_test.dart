import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_app/main.dart';

void main() {
  testWidgets('shows benchmark UI defaults', (tester) async {
    await tester.pumpWidget(const BenchmarkApp());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('2000'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Test'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Test Array'), findsOneWidget);
  });

  testWidgets('runs math benchmark and shows total', (tester) async {
    await tester.pumpWidget(const BenchmarkApp());

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Test'));
    await tester.pump();

    expect(find.textContaining('Execution time:'), findsOneWidget);
    expect(find.textContaining('Hasil: 27'), findsOneWidget);
  });

  testWidgets('runs array benchmark and shows execution text', (tester) async {
    await tester.pumpWidget(const BenchmarkApp());

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Test Array'));
    await tester.pump();
    final expectedJsonLength = jsonEncode(List.generate(10, (index) {
      final i = index + 1;
      return {'id': i, 'name': 'User_$i', 'score': i * 1.5};
    })).length;

    expect(find.textContaining('Array manipulation time:'), findsOneWidget);
    expect(
      find.textContaining('JSON length: $expectedJsonLength'),
      findsOneWidget,
    );
  });
}
