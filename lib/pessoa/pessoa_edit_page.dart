import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/pessoa/pessoa.dart';
import 'package:viveira/pessoa/pessoa_edit_controller.dart';

class PessoaEditPage extends ConsumerStatefulWidget {
  final String? pessoaId;
  const PessoaEditPage({super.key, required this.pessoaId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PessoaEditPageState();
}

class _PessoaEditPageState extends ConsumerState<PessoaEditPage> {
  get isNewPessoa => widget.pessoaId == null;
  Pessoa? pessoa;
  late final TextEditingController _nomeController;
  late final TextEditingController _cpfController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _cpfController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pessoaAsync =
        ref.watch(pessoaEditControllerProvider(widget.pessoaId));

    if (pessoa == null && pessoaAsync.hasValue) {
      pessoa = pessoaAsync.value!.copyWith();
      _nomeController.text = pessoa!.nome;
      _cpfController.text = pessoa!.cpf;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewPessoa ? "Adicionar" : "Editar"} Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pessoaAsync.when(
          data: (originalPessoa) => _buildForm(context),
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
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                pessoa = pessoa!.copyWith(nome: value);
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
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                pessoa = pessoa!.copyWith(cpf: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
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
          child: Text(isNewPessoa ? 'Create' : 'Save'),
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
        ref.read(pessoaEditControllerProvider(widget.pessoaId).notifier);
    await notifier.updateState(pessoa!);
    await notifier.save();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
