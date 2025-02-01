import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/observacao/observacao_edit_page.dart';
import 'package:viveira/observacao/observacao_filter.dart';
import 'package:viveira/observacao/observacao_list_controller.dart';
import 'package:viveira/observacao/observacao.dart';

class ObservacaoListPage extends ConsumerWidget {
  const ObservacaoListPage({super.key});

  void _onUpdate(WidgetRef ref) {
    ref.read(observacaoListControllerProvider.notifier).find();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final observacaoList = ref.watch(observacaoListControllerProvider);
    final observacaoFilter = ref.watch(observacaoFilterControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observações'),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(observacaoFilter.isEmpty
                  ? Icons.filter_alt_off
                  : Icons.filter_alt),
              onPressed: () {
                showBottomSheet(
                  context: context,
                  builder: (context) => const ObservacaoFilterWidget(),
                );
              },
            );
          }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final saved = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ObservacaoEditPage(
                    observacaoId: null,
                  ),
                ),
              );
              if (saved == true) {
                _onUpdate(ref);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: observacaoList.when(
          data: (list) => _buildObservacaoList(ref, list),
          error: _buildError,
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget? _buildError(error, stackTrace) => Center(
        child: Column(
          children: [
            Text('Error: $error'),
            Text('Stack trace: $stackTrace'),
          ],
        ),
      );

  Widget? _buildObservacaoList(WidgetRef ref, List<Observacao> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('Nenhuma observação cadastrada'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Observacao observacao = list[index];
          return ListTile(
            title: Text(observacao.descricao),
            subtitle: Text(observacao.timestamp.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // create dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Observacao'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref
                              .read(observacaoListControllerProvider.notifier)
                              .delete(observacao);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () async {
              final saved = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ObservacaoEditPage(observacaoId: observacao.id),
                ),
              );
              if (saved == true) {
                _onUpdate(ref);
              }
            },
          );
        },
      );
    }
  }
}
