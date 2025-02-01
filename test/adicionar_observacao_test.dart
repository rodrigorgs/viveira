// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/o_app_esta_rodando.dart';
import './step/as_seguintes_pessoas_existem.dart';
import './step/hoje_e.dart';
import './step/eu_adiciono_uma_observacao_com.dart';
import './step/eu_vejo_o_texto.dart';
import './step/eu_nao_vejo_o_texto.dart';

void main() {
  group('''Adicionar observacao''', () {
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

    testWidgets('''Adicionar observação com data futura''', (tester) async {
      await bddSetUp(tester);
      await hojeE(tester, '2020-01-01');
      await euAdicionoUmaObservacaoCom(
          tester,
          const bdd.DataTable([
            ['Descrição', 'Categoria', 'Data/hora'],
            ['Oficina', 'x', '2020-01-02']
          ]));
      await euVejoOTexto(tester, 'Data inválida');
    });
    testWidgets('''Adicionar observação com data passada''', (tester) async {
      await bddSetUp(tester);
      await hojeE(tester, '2020-01-01');
      await euAdicionoUmaObservacaoCom(
          tester,
          const bdd.DataTable([
            ['Descrição', 'Categoria', 'Data/hora'],
            ['Oficina', 'x', '2019-12-31']
          ]));
      await euNaoVejoOTexto(tester, 'Data inválida');
    });
  });
}
