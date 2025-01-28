import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/pessoa/pessoa_list_controller.dart';
import 'package:viveira/pessoa/pessoa.dart';

class PessoaSelectPage extends ConsumerStatefulWidget {
  final Set<String> selectedPessoaIds;
  final Function(Set<String> selectedPessoas) onChangeSelection;

  const PessoaSelectPage({
    super.key,
    required this.selectedPessoaIds,
    required this.onChangeSelection,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PessoaSelectPageState();
}

class _PessoaSelectPageState extends ConsumerState<PessoaSelectPage> {
  final Set<String> selectedPessoaIds = {};

  @override
  void initState() {
    super.initState();
    selectedPessoaIds.addAll(widget.selectedPessoaIds);
  }

  void _onSelect(WidgetRef ref, String? pessoaId) {
    if (pessoaId == null) {
      return;
    }

    if (selectedPessoaIds.contains(pessoaId)) {
      selectedPessoaIds.remove(pessoaId);
    } else {
      selectedPessoaIds.add(pessoaId);
    }

    widget.onChangeSelection(selectedPessoaIds.toSet());
  }

  @override
  Widget build(BuildContext context) {
    final pessoaList = ref.watch(pessoaListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas'),
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
        child: Text('Nenhuma pessoa cadastrada'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Pessoa pessoa = list[index];
          return ListTile(
            title: Text(pessoa.nome),
            leading: selectedPessoaIds.contains(pessoa.id)
                ? const Icon(Icons.check)
                : const SizedBox.square(dimension: 24),
            onTap: () {
              setState(() {
                _onSelect(ref, pessoa.id);
              });
            },
          );
        },
      );
    }
  }
}
