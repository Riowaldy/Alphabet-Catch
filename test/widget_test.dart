import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alphabet_catch/main.dart';

void main() {
  testWidgets('App starts on the player info screen, then the start screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AlphabetCatchApp());

    expect(find.text('Siapa Namamu?'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Nama'), 'Aiko');
    await tester.enterText(find.widgetWithText(TextField, 'Usia'), '7');
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Alphabet Catch!'), findsOneWidget);
    expect(find.text('Halo, Aiko (7 tahun)! 👋'), findsOneWidget);
    expect(find.text('Mulai Main'), findsOneWidget);
  });
}
