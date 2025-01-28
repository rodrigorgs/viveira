import 'package:flutter_test/flutter_test.dart';

/// Usage: eu vejo o texto {'2020-01-03'}
Future<void> euVejoOTexto(WidgetTester tester, String text) async {
  expect(find.textContaining(text), findsOneWidget);
}
