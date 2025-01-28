import 'package:flutter_test/flutter_test.dart';

/// Usage: eu visualizo as pessoas
Future<void> euVisualizoAsPessoas(WidgetTester tester) async {
  await tester.tap(find.text('Pessoas'));
  await tester.pumpAndSettle();
}
