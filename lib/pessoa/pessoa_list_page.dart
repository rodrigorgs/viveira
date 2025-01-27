import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/pessoa/pessoa_edit_page.dart';
import 'package:viveira/pessoa/pessoa_list_controller.dart';
import 'package:viveira/pessoa/pessoa.dart';

class PessoaListPage extends ConsumerWidget {
  const PessoaListPage({super.key});

  void _onUpdate(WidgetRef ref) {
    ref.read(pessoaListControllerProvider.notifier).find();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pessoaList = ref.watch(pessoaListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoa List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PessoaEditPage(
                pessoaId: null,
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
        child: pessoaList.when(
          data: (list) => _buildPessoaList(ref, list),
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

  Widget? _buildPessoaList(WidgetRef ref, List<Pessoa> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No pessoas found'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Pessoa pessoa = list[index];
          return ListTile(
            title: Text(pessoa.title),
            subtitle: Text(pessoa.isCompleted ? 'Completed' : 'Not completed'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // create dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Pessoa'),
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
                              .read(pessoaListControllerProvider.notifier)
                              .delete(pessoa);
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
                  builder: (context) => PessoaEditPage(pessoaId: pessoa.id),
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
