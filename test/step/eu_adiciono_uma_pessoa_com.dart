import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';
import 'eu_visualizo_as_pessoas.dart';

/// Usage: eu adiciono uma pessoa com
Future<void> euAdicionoUmaPessoaCom(
    WidgetTester tester, bdd.DataTable dataTable) async {
  await euVisualizoAsPessoas(tester);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  final pessoa = dataTable.asMaps().first;
  for (final entry in pessoa.entries) {
    final textField = findTextFieldByLabel(tester, entry.key);
    await tester.enterText(textField, entry.value);
  }
  await tester.pumpAndSettle();
  await tester.tap(find.text('Criar'));
  await tester.pumpAndSettle();
}
