// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/o_app_esta_rodando.dart';
import './step/as_seguintes_pessoas_existem.dart';
import './step/eu_visualizo_as_pessoas.dart';
import './step/eu_vejo_na_posicao_da_lista.dart';

void main() {
  group('''Listar pessoas''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRodando(tester);
      await asSeguintesPessoasExistem(
          tester,
          const bdd.DataTable([
            ['id', 'nome', 'cpf'],
            ['1', 'Fulano', '123'],
            ['2', 'Sicrano', '456'],
            ['3', 'Beltrano', '789']
          ]));
    }

    testWidgets('''As pessoas estão ordenadas por nome''', (tester) async {
      await bddSetUp(tester);
      await euVisualizoAsPessoas(tester);
      await euVejoNaPosicaoDaLista(tester, 'Beltrano', 1);
      await euVejoNaPosicaoDaLista(tester, 'Fulano', 2);
      await euVejoNaPosicaoDaLista(tester, 'Sicrano', 3);
    });
  });
}
