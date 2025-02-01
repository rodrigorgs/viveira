import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: a lista possui tamanho {1}
Future<void> aListaPossuiTamanho(WidgetTester tester, num size) async {
  final listTiles = find.byType(ListTile).evaluate().toList();
  expect(listTiles.length, size);
}
