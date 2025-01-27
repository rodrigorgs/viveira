import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/pessoa/pessoa.dart';
import 'package:viveira/pessoa/pessoa_list_controller.dart';
import 'package:viveira/projeto/projeto.dart';
import 'package:viveira/projeto/projeto_edit_controller.dart';

class ProjetoEditPage extends ConsumerStatefulWidget {
  final String? projetoId;
  const ProjetoEditPage({super.key, required this.projetoId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProjetoEditPageState();
}

class _ProjetoEditPageState extends ConsumerState<ProjetoEditPage> {
  get isNewProjeto => widget.projetoId == null;
  Projeto? projeto;
  late final TextEditingController _tituloController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _acaoController;
  String _estudanteId = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _descricaoController = TextEditingController();
    _acaoController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _acaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projetoAsync =
        ref.watch(projetoEditControllerProvider(widget.projetoId));

    if (projeto == null && projetoAsync.hasValue) {
      projeto = projetoAsync.value!.copyWith();
      _tituloController.text = projeto!.titulo;
      _descricaoController.text = projeto!.descricao;
      _acaoController.text = projeto!.acao;
      _estudanteId = projeto!.estudanteId;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewProjeto ? "Adicionar" : "Editar"} Projeto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: projetoAsync.when(
          data: (originalProjeto) => _buildForm(context),
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
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                projeto = projeto!.copyWith(titulo: value);
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
              minLines: 4,
              maxLines: 7,
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição (incluir 3 a 5 perguntas)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                projeto = projeto!.copyWith(descricao: value);
              },
              validator: (value) => null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              controller: _acaoController,
              decoration: const InputDecoration(
                labelText: 'Ação/resultado',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                projeto = projeto!.copyWith(titulo: value);
              },
              validator: (value) => null,
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final pessoasAsync = ref.watch(pessoaListControllerProvider);
                return pessoasAsync.when(
                  data: (pessoas) {
                    return _estudanteSelector(pessoas);
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildButtonBar(ref, context),
          ],
        ),
      ),
    );
  }

  Widget _estudanteSelector(List<Pessoa> pessoas) {
    return DropdownButtonFormField<String>(
      value: _estudanteId.isEmpty ? null : _estudanteId,
      items: pessoas.map((pessoa) {
        return DropdownMenuItem<String>(
          value: pessoa.id,
          child: Text(pessoa.nome),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _estudanteId = newValue!;
          projeto = projeto!.copyWith(
            estudanteId: _estudanteId,
            estudanteNome: pessoas.firstWhere((p) => p.id == _estudanteId).nome,
          );
        });
      },
      decoration: const InputDecoration(
        labelText: 'Estudante',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Row _buildButtonBar(WidgetRef ref, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _save,
          child: Text(isNewProjeto ? 'Create' : 'Save'),
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
    final notifier =
        ref.read(projetoEditControllerProvider(widget.projetoId).notifier);
    await notifier.updateState(projeto!);
    await notifier.save();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
