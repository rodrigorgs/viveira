import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';

part 'observacao_filter.g.dart';

class ObservacaoFilter {
  final String descricao;
  final DateTime? timestamp;
  final String? categoria;
  final String? pessoa;

  const ObservacaoFilter({
    this.descricao = '',
    this.timestamp,
    this.categoria,
    this.pessoa,
  });

  get isEmpty =>
      descricao.isEmpty &&
      timestamp == null &&
      categoria == null &&
      pessoa == null;

  get timestampString =>
      timestamp == null ? '' : DateFormat('yyyy-MM-dd').format(timestamp!);
}

@riverpod
class ObservacaoFilterController extends _$ObservacaoFilterController {
  @override
  ObservacaoFilter build() {
    return const ObservacaoFilter();
  }

  void filterBy(ObservacaoFilter filter) {
    state = filter;
  }
}

class ObservacaoFilterWidget extends ConsumerStatefulWidget {
  const ObservacaoFilterWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ObservacaoFilterWidgetState();
}

class _ObservacaoFilterWidgetState
    extends ConsumerState<ObservacaoFilterWidget> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _categoriaController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(observacaoFilterControllerProvider);

    _descricaoController.text = filter.descricao;
    _categoriaController.text = filter.categoria ?? '';
    _dataController.text = filter.timestampString;

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Filtro de Observações'),
              const SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _descricaoController.clear,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Data',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _dataController.clear,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _categoriaController,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _categoriaController.clear,
                  ),
                ),
              ),
              // const SizedBox(height: 16),
              // const TextField(
              //   decoration: InputDecoration(
              //     labelText: 'Pessoa',
              //   ),
              // ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(observacaoFilterControllerProvider.notifier)
                          .filterBy(const ObservacaoFilter());
                      Navigator.of(context).pop();
                    },
                    child: const Text('Limpar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(observacaoFilterControllerProvider.notifier)
                          .filterBy(ObservacaoFilter(
                            descricao: _descricaoController.text,
                            categoria: _categoriaController.text,
                            timestamp: DateTime.tryParse(_dataController.text),
                          ));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Filtrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
