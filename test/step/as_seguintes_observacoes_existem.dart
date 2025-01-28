import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter_test/flutter_test.dart';
import 'package:viveira/observacao/observacao.dart';
import 'package:viveira/observacao/observacao_repository.dart';

import '../util.dart';

/// Usage: as seguintes observações existem:
Future<void> asSeguintesObservacoesExistem(
    WidgetTester tester, bdd.DataTable dataTable) async {
  final ref = getRiverpodRef(tester);
  final repository = ref.read(observacaoRepositoryProvider);

  dataTable.asMaps().forEach((row) async {
    row['autorId'] = row['autor'];
    row['envolvidosIds'] = {for (var e in row['envolvidos']) e: true};
    final observacao = Observacao.fromJson(Map<String, dynamic>.from(row));
    await repository.insert(observacao);
  });
}
