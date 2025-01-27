import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/projeto/projeto.dart';
import 'package:viveira/projeto/projeto_edit_controller.dart';

class ProjetoEditPage extends ConsumerStatefulWidget {
  final String? projetoId;
  const ProjetoEditPage({super.key, required this.projetoId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjetoEditPageState();
}

class _ProjetoEditPageState extends ConsumerState<ProjetoEditPage> {
  get isNewProjeto => widget.projetoId == null;
  Projeto? projeto;
  late final TextEditingController _titleController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projetoAsync = ref.watch(projetoEditControllerProvider(widget.projetoId));

    if (projeto == null && projetoAsync.hasValue) {
      projeto = projetoAsync.value!.copyWith();
      _titleController.text = projeto!.title;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewProjeto ? "New" : "Edit"} Projeto'),
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Projeto title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                projeto = projeto!.copyWith(title: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            CheckboxListTile(
              title: const Text('Is completed'),
              value: projeto!.isCompleted,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  projeto = projeto!.copyWith(isCompleted: value!);
                });
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
