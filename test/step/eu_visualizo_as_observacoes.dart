import 'package:flutter_test/flutter_test.dart';

/// Usage: eu visualizo as observações
Future<void> euVisualizoAsObservacoes(WidgetTester tester) async {
  await tester.tap(find.text('Observações'));
  await tester.pumpAndSettle();
}
