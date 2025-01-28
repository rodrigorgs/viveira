import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/observacao/observacao.dart';
import 'package:viveira/observacao/observacao_repository.dart';

part 'observacao_list_controller.g.dart';

@riverpod
class ObservacaoListController extends _$ObservacaoListController {
  @override
  Future<List<Observacao>> build() async {
    return ref.read(observacaoRepositoryProvider).find();
  }

  Future<void> find() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(observacaoRepositoryProvider).find);
  }

  Future<void> delete(Observacao observacao) async {
    final observacaoRepository = ref.read(observacaoRepositoryProvider);
    state = const AsyncValue.loading();
    await observacaoRepository.delete(observacao.id!);
    state = await AsyncValue.guard(observacaoRepository.find);
  }
}
