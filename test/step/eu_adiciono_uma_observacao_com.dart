import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';
import 'eu_visualizo_as_observacoes.dart';

/// Usage: eu adiciono uma observação com
Future<void> euAdicionoUmaObservacaoCom(
    WidgetTester tester, bdd.DataTable dataTable) async {
  await euVisualizoAsObservacoes(tester);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  final observacao = dataTable.asMaps().first;
  for (final entry in observacao.entries) {
    final textField = findTextFieldByLabel(tester, entry.key);
    await tester.enterText(textField, entry.value);
  }
  await tester.pumpAndSettle();
  await tester.tap(find.text('Criar'));
  await tester.pumpAndSettle();
}
