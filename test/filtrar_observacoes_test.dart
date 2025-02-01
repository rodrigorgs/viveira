// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/o_app_esta_rodando.dart';
import './step/as_seguintes_pessoas_existem.dart';
import './step/as_seguintes_observacoes_existem.dart';
import './step/eu_visualizo_as_observacoes.dart';
import './step/eu_filtro_por.dart';
import './step/a_lista_possui_tamanho.dart';
import './step/eu_vejo_na_posicao_da_lista.dart';
import './step/eu_vejo_o_texto.dart';
import './step/eu_nao_vejo_o_texto.dart';

void main() {
  group('''Filtrar observações''', () {
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
      await asSeguintesObservacoesExistem(
          tester,
          const bdd.DataTable([
            ['descricao', 'categoria', 'timestamp', 'envolvidos', 'autor'],
            [
              'Oficina de cupcake',
              'x',
              '2020-01-03',
              {'1'},
              '3'
            ],
            [
              'Oficina de argila',
              'x',
              '2020-01-01',
              {'1', '2'},
              '3'
            ],
            [
              'Oficina de compostagem',
              'y',
              '2020-01-02',
              {'1', '2', '3'},
              '3'
            ]
          ]));
    }

    testWidgets('''(eqE) Filtrar por descrição''', (tester) async {
      await bddSetUp(tester);
      await euVisualizoAsObservacoes(tester);
      await euFiltroPor(
          tester,
          const bdd.DataTable([
            ['Descrição'],
            ['argila']
          ]));
      await aListaPossuiTamanho(tester, 1);
      await euVejoNaPosicaoDaLista(tester, 'Oficina de argila', 1);
    });
    testWidgets('''(eqB) Filtrar observações por categoria existente''',
        (tester) async {
      await bddSetUp(tester);
      await euVisualizoAsObservacoes(tester);
      await euFiltroPor(
          tester,
          const bdd.DataTable([
            ['Categoria'],
            ['x']
          ]));
      await euVejoOTexto(tester, 'Oficina de cupcake');
      await euVejoOTexto(tester, 'Oficina de argila');
      await euNaoVejoOTexto(tester, 'Oficina de compostagem');
    });
    testWidgets('''(eqB) Filtrar observações por categoria não existente''',
        (tester) async {
      await bddSetUp(tester);
      await euVisualizoAsObservacoes(tester);
      await euFiltroPor(
          tester,
          const bdd.DataTable([
            ['Categoria'],
            ['inexistente']
          ]));
      await euVejoOTexto(tester, 'Nenhuma observação');
    });
  });
}
