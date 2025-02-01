import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/observacao/observacao.dart';
import 'package:viveira/observacao/observacao_repository.dart';
import 'package:viveira/today_provider.dart';

part 'observacao_edit_controller.g.dart';

@riverpod
class ObservacaoEditController extends _$ObservacaoEditController {
  @override
  Future<Observacao> build(String? observacaoId) async {
    if (observacaoId == null) {
      return Future.value(_withCurrentTimestamp(Observacao.empty()));
    } else {
      final observacao =
          await ref.read(observacaoRepositoryProvider).findById(observacaoId);
      if (observacao == null) {
        throw Exception('Observacao not found');
      }
      return _withCurrentTimestamp(observacao);
    }
  }

  Observacao _withCurrentTimestamp(Observacao observacao) {
    if (observacao.timestamp != null) {
      return observacao;
    }
    return observacao.copyWith(timestamp: ref.read(todayFunctionProvider)());
  }

  Future<void> updateState(Observacao observacao) async {
    state = AsyncValue.data(observacao);
  }

  Future<void> save() async {
    Observacao observacao = state.value!;
    final observacaoRepository = ref.read(observacaoRepositoryProvider);
    state = const AsyncValue.loading();
    if (observacao.id == null) {
      observacao = await observacaoRepository.insert(observacao);
    } else {
      await observacaoRepository.update(observacao.id!, observacao);
    }
    state = await AsyncValue.guard(() => Future.value(observacao));
  }
}
