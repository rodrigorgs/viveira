import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/projeto/projeto_edit_page.dart';
import 'package:viveira/projeto/projeto_list_controller.dart';
import 'package:viveira/projeto/projeto.dart';

class ProjetoListPage extends ConsumerWidget {
  const ProjetoListPage({super.key});

  void _onUpdate(WidgetRef ref) {
    ref.read(projetoListControllerProvider.notifier).find();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projetoList = ref.watch(projetoListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProjetoEditPage(
                projetoId: null,
              ),
            ),
          );
          if (saved == true) {
            _onUpdate(ref);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: projetoList.when(
          data: (list) => _buildProjetoList(ref, list),
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

  Widget? _buildProjetoList(WidgetRef ref, List<Projeto> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('Nenhum projeto cadastrado'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Projeto projeto = list[index];
          return ListTile(
            title: Text(projeto.titulo),
            subtitle: Text(projeto.estudanteNome ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // create dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Projeto'),
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
                              .read(projetoListControllerProvider.notifier)
                              .delete(projeto);
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
                  builder: (context) => ProjetoEditPage(projetoId: projeto.id),
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
