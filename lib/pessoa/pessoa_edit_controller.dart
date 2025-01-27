import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/pessoa/pessoa.dart';
import 'package:viveira/pessoa/pessoa_repository.dart';

part 'pessoa_edit_controller.g.dart';

@riverpod
class PessoaEditController extends _$PessoaEditController {
  @override
  Future<Pessoa> build(String? pessoaId) async {
    if (pessoaId == null) {
      return Future.value(Pessoa.empty());
    } else {
      final pessoa = await ref.read(pessoaRepositoryProvider).findById(pessoaId);
      if (pessoa == null) {
        throw Exception('Pessoa not found');
      }
      return pessoa;
    }
  }

  Future<void> updateState(Pessoa pessoa) async {
    state = AsyncValue.data(pessoa);
  }

  Future<void> save() async {
    Pessoa pessoa = state.value!;
    final pessoaRepository = ref.read(pessoaRepositoryProvider);
    state = const AsyncValue.loading();
    if (pessoa.id == null) {
      pessoa = await pessoaRepository.insert(pessoa);
    } else {
      await pessoaRepository.update(pessoa.id!, pessoa);
    }
    state = await AsyncValue.guard(() => Future.value(pessoa));
  }
}
