import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/pessoa/pessoa.dart';
import 'package:viveira/pessoa/pessoa_repository.dart';

part 'pessoa_list_controller.g.dart';

@riverpod
class PessoaListController extends _$PessoaListController {
  @override
  Future<List<Pessoa>> build() async {
    return ref.read(pessoaRepositoryProvider).find();
  }

  Future<void> find() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(pessoaRepositoryProvider).find);
  }

  Future<void> delete(Pessoa pessoa) async {
    final pessoaRepository = ref.read(pessoaRepositoryProvider);
    state = const AsyncValue.loading();
    await pessoaRepository.delete(pessoa.id!);
    state = await AsyncValue.guard(pessoaRepository.find);
  }
}
