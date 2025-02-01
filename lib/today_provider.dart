import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_provider.g.dart';

@riverpod
DateTime Function() todayFunction(Ref ref) {
  return () => DateTime.now();
}
