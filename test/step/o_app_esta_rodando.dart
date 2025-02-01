import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viveira/home_page.dart';
import 'package:viveira/firestore_provider.dart';
import 'package:viveira/today_provider.dart';

import '../util.dart';

/// Usage: o app está rodando
Future<void> oAppEstaRodando(WidgetTester tester) async {
  await tester.pumpWidget(ProviderScope(
    overrides: [
      firebaseFirestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
      todayFunctionProvider.overrideWithValue(() => today),
    ],
    child: const MaterialApp(
      home: HomePage(),
    ),
  ));
}
