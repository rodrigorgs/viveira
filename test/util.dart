import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime today = DateTime(2999, 12, 25);

getRiverpodRef(WidgetTester tester) {
  final elem = tester.element(find.byType(MaterialApp));
  final ref = ProviderScope.containerOf(elem);
  return ref;
}

findTextFieldByLabel(WidgetTester tester, String key) {
  final textField = find.byWidgetPredicate((widget) {
    if (widget is TextField) {
      final decoration = widget.decoration as InputDecoration;
      return decoration.labelText?.toLowerCase() == key.toLowerCase();
    }
    return false;
  });
  return textField;
}
