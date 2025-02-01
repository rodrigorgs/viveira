import 'package:flutter_test/flutter_test.dart';

import '../util.dart';

/// Usage: hoje é {'2020-01-01'}
Future<void> hojeE(WidgetTester tester, String param1) async {
  today = DateTime.parse(param1);
}
