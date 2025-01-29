import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/observacao/observacao.dart';
import 'package:viveira/observacao/observacao_edit_controller.dart';
import 'package:viveira/pessoa/pessoa_list_controller.dart';
import 'package:viveira/pessoa/pessoa_select_page.dart';

class ObservacaoEditPage extends ConsumerStatefulWidget {
  final String? observacaoId;
  const ObservacaoEditPage({super.key, required this.observacaoId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ObservacaoEditPageState();
}

class _ObservacaoEditPageState extends ConsumerState<ObservacaoEditPage> {
  get isNewObservacao => widget.observacaoId == null;
  Observacao? observacao;
  late final TextEditingController _descricaoController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _timestampController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController();
    _categoriaController = TextEditingController();
    _timestampController = TextEditingController();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _categoriaController.dispose();
    _timestampController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final observacaoAsync =
        ref.watch(observacaoEditControllerProvider(widget.observacaoId));

    if (observacao == null && observacaoAsync.hasValue) {
      observacao = observacaoAsync.value!.copyWith();
      _descricaoController.text = observacao!.descricao;
      _categoriaController.text = observacao!.categoria;
      _timestampController.text = observacao!.timestamp.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewObservacao ? "New" : "Edit"} Observacao'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: observacaoAsync.when(
          data: (originalObservacao) => _buildForm(context),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              autofocus: true,
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                observacao = observacao!.copyWith(descricao: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                observacao = observacao!.copyWith(categoria: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timestampController,
              decoration: const InputDecoration(
                labelText: 'Data/hora',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                observacao =
                    observacao!.copyWith(timestamp: DateTime.parse(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildParticipantes(context),
            const SizedBox(height: 16),
            _buildButtonBar(ref, context),
          ],
        ),
      ),
    );
  }

  Row _buildButtonBar(WidgetRef ref, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _save,
          child: Text(isNewObservacao ? 'Create' : 'Save'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel')),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref
        .read(observacaoEditControllerProvider(widget.observacaoId).notifier);
    await notifier.updateState(observacao!);
    await notifier.save();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  _buildParticipantes(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Envolvidos:'),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PessoaSelectPage(
                        selectedPessoaIds:
                            observacao!.envolvidosIds.keys.toSet(),
                        onChangeSelection: (value) {
                          setState(() {
                            final newEnvolvidos = Map.fromEntries(
                                value.map((id) => MapEntry(id, true)));
                            observacao = observacao!
                                .copyWith(envolvidosIds: newEnvolvidos);
                          });
                        }),
                  ),
                );
              },
              label: const Icon(Icons.edit),
            ),
            const SizedBox(width: 16),
            Consumer(
              builder: (context, ref, child) {
                final pessoasAsync = ref.watch(pessoaListControllerProvider);
                return pessoasAsync.when(
                  data: (pessoas) {
                    if (pessoas.isEmpty) {
                      return const Text('Nenhuma pessoa cadastrada');
                    } else {
                      final selectedPessoas = pessoas
                          .where((pessoa) => observacao!.envolvidosIds
                              .containsKey(pessoa.id ?? ''))
                          .toList();
                      return Wrap(
                        spacing: 8,
                        children: selectedPessoas
                            .map(
                              (pessoa) => Chip(
                                label: Text(pessoa.nome),
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
