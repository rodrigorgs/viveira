import 'package:flutter_test/flutter_test.dart';

/// Usage: eu não vejo o texto {'Oficina de compostagem'}
Future<void> euNaoVejoOTexto(WidgetTester tester, String text) async {
  expect(find.textContaining(text), findsNothing);
}
