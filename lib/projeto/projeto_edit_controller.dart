import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/projeto/projeto.dart';
import 'package:viveira/projeto/projeto_repository.dart';

part 'projeto_edit_controller.g.dart';

@riverpod
class ProjetoEditController extends _$ProjetoEditController {
  @override
  Future<Projeto> build(String? projetoId) async {
    if (projetoId == null) {
      return Future.value(Projeto.empty());
    } else {
      final projeto = await ref.read(projetoRepositoryProvider).findById(projetoId);
      if (projeto == null) {
        throw Exception('Projeto not found');
      }
      return projeto;
    }
  }

  Future<void> updateState(Projeto projeto) async {
    state = AsyncValue.data(projeto);
  }

  Future<void> save() async {
    Projeto projeto = state.value!;
    final projetoRepository = ref.read(projetoRepositoryProvider);
    state = const AsyncValue.loading();
    if (projeto.id == null) {
      projeto = await projetoRepository.insert(projeto);
    } else {
      await projetoRepository.update(projeto.id!, projeto);
    }
    state = await AsyncValue.guard(() => Future.value(projeto));
  }
}
