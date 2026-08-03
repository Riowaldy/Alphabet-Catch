import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alphabet_catch/main.dart';

Future<void> _skipSplash(WidgetTester tester) async {
  await tester.tap(find.text('Ketuk untuk mulai ✨'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'First run: splash leads to player info screen, then the start screen',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AlphabetCatchApp());
    expect(find.text('Ketuk untuk mulai ✨'), findsOneWidget);

    await _skipSplash(tester);
    expect(find.text('Siapa Namamu?'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Nama'), 'Aiko');
    await tester.enterText(find.widgetWithText(TextField, 'Usia'), '7');
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Alphabet Catch!'), findsOneWidget);
    expect(find.text('Halo, Aiko (7 tahun)! 👋'), findsOneWidget);
    expect(find.text('Mulai Main'), findsOneWidget);
  });

  testWidgets(
      'Returning player: splash leads straight to the start screen, skipping player info',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'player_name': 'Bela',
      'player_age': 6,
    });

    await tester.pumpWidget(const AlphabetCatchApp());
    await _skipSplash(tester);

    expect(find.text('Siapa Namamu?'), findsNothing);
    expect(find.text('Halo, Bela (6 tahun)! 👋'), findsOneWidget);
  });
}
