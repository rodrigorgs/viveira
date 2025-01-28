import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: eu vejo {'Ana'} na posição {1} da lista
Future<void> euVejoNaPosicaoDaLista(
    WidgetTester tester, String text, num position) async {
  int index = position.toInt() - 1;
  final listTiles = find
      .byType(ListTile)
      .evaluate()
      .map((e) => e.widget as ListTile)
      .toList();

  expect(listTiles.length, greaterThan(index));
  expect(
    find.descendant(
      of: find.byWidget(listTiles.elementAt(index)),
      matching: find.text(text),
    ),
    findsOneWidget,
  );
}
