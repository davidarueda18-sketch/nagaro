import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nagaro/app.dart';

void main() {
  testWidgets('NagaroApp renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NagaroApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
