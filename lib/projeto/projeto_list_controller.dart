import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/projeto/projeto.dart';
import 'package:viveira/projeto/projeto_repository.dart';

part 'projeto_list_controller.g.dart';

@riverpod
class ProjetoListController extends _$ProjetoListController {
  @override
  Future<List<Projeto>> build() async {
    return ref.read(projetoRepositoryProvider).find();
  }

  Future<void> find() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(projetoRepositoryProvider).find);
  }

  Future<void> delete(Projeto projeto) async {
    final projetoRepository = ref.read(projetoRepositoryProvider);
    state = const AsyncValue.loading();
    await projetoRepository.delete(projeto.id!);
    state = await AsyncValue.guard(projetoRepository.find);
  }
}
