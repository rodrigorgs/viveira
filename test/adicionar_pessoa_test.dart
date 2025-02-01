// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/o_app_esta_rodando.dart';
import './step/eu_adiciono_uma_pessoa_com.dart';
import './step/eu_vejo_o_texto.dart';
import './step/eu_nao_vejo_o_texto.dart';

void main() {
  group('''Adicionar pessoa''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRodando(tester);
    }

    testWidgets('''(eqE) Adicionar Pessoa com nome inválido''', (tester) async {
      await bddSetUp(tester);
      await euAdicionoUmaPessoaCom(
          tester,
          const bdd.DataTable([
            ['Nome completo', 'CPF'],
            ['abcde0', '123']
          ]));
      await euVejoOTexto(tester, 'Nome inválido');
    });
    testWidgets('''(eqE) Adicionar Pessoa com CPF inválido''', (tester) async {
      await bddSetUp(tester);
      await euAdicionoUmaPessoaCom(
          tester,
          const bdd.DataTable([
            ['CPF'],
            ['1234567890']
          ]));
      await euVejoOTexto(tester, 'CPF inválido');
    });
    testWidgets('''Adicionar Pessoa com CPF válido''', (tester) async {
      await bddSetUp(tester);
      await euAdicionoUmaPessoaCom(
          tester,
          const bdd.DataTable([
            ['CPF'],
            ['64218723010']
          ]));
      await euNaoVejoOTexto(tester, 'CPF inválido');
    });
  });
}
