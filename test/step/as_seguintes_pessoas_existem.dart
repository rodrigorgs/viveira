import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter_test/flutter_test.dart';
import 'package:viveira/pessoa/pessoa.dart';
import 'package:viveira/pessoa/pessoa_repository.dart';

import '../util.dart';

/// Usage: as seguintes pessoas existem:
Future<void> asSeguintesPessoasExistem(
    WidgetTester tester, bdd.DataTable dataTable) async {
  final ref = getRiverpodRef(tester);
  final pessoaRepository = ref.read(pessoaRepositoryProvider);

  dataTable.asMaps().forEach((row) async {
    final pessoa = Pessoa.fromJson(Map<String, dynamic>.from(row));
    await pessoaRepository.insert(pessoa);
  });
}
