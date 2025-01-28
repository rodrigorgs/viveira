import 'package:flutter/material.dart';
import 'package:viveira/observacao/observacao_list_page.dart';
import 'package:viveira/pessoa/pessoa_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 16,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const ObservacaoListPage()));
              },
              child: const Text('Observações'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const PessoaListPage()));
              },
              child: const Text('Pessoas'),
            ),
          ],
        ),
      ),
    );
  }
}
