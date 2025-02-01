import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:viveira/observacao/observacao.dart';
import 'package:viveira/observacao/observacao_filter.dart';
import 'package:viveira/observacao/observacao_repository.dart';

part 'observacao_list_controller.g.dart';

@riverpod
class ObservacaoListController extends _$ObservacaoListController {
  @override
  Future<List<Observacao>> build() async {
    return _getResult();
  }

  Future<void> find() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getResult);
  }

  Future<void> delete(Observacao observacao) async {
    final observacaoRepository = ref.read(observacaoRepositoryProvider);
    state = const AsyncValue.loading();
    await observacaoRepository.delete(observacao.id!);
    state = await AsyncValue.guard(observacaoRepository.find);
  }

  Future<List<Observacao>> _getResult() async {
    final filter = ref.watch(observacaoFilterControllerProvider);

    final result = await ref.read(observacaoRepositoryProvider).find();

    final formatter = DateFormat('yyyy-MM-dd');
    final filtered = result.where((observacao) {
      if (!observacao.descricao
          .toLowerCase()
          .contains(filter.descricao.toLowerCase())) {
        return false;
      }
      if (filter.categoria != null &&
          filter.categoria!.isNotEmpty &&
          observacao.categoria != filter.categoria) {
        return false;
      }
      if (filter.timestamp != null &&
          !formatter
              .format(observacao.timestamp!)
              .contains(formatter.format(filter.timestamp!))) {
        return false;
      }
      return true;
    });

    return filtered.toList();
  }
}
