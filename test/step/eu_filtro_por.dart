import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';

/// Usage: eu filtro por
Future<void> euFiltroPor(WidgetTester tester, bdd.DataTable dataTable) async {
  var iconFinder = find.byIcon(Icons.filter_alt);
  if (!iconFinder.hasFound) {
    iconFinder = find.byIcon(Icons.filter_alt_off);
  }
  await tester.tap(iconFinder);
  await tester.pumpAndSettle();

  for (final row in dataTable.asMaps()) {
    for (final entry in row.entries) {
      final textField = findTextFieldByLabel(tester, entry.key);
      await tester.enterText(textField, entry.value);
    }
  }

  await tester.pumpAndSettle();
  await tester.tap(find.text('Filtrar'));
  await tester.pumpAndSettle();
}
