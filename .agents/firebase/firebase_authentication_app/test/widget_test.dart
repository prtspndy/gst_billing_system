import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Firebase Auth Demo'))),
      ),
    );

    expect(find.text('Firebase Auth Demo'), findsOneWidget);
  });
}
