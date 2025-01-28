import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'observacao.freezed.dart';
part 'observacao.g.dart';

@freezed
class Observacao with _$Observacao {
  const factory Observacao({
    String? id,
    required String descricao,
    required String categoria,
    required Map<String, bool> envolvidosIds, // pessoa
    required DateTime timestamp,
    required String autorId, // pessoa
    String? anexo,
  }) = _Observacao;

  factory Observacao.empty() => Observacao(
        id: null,
        descricao: '',
        categoria: '',
        envolvidosIds: {},
        timestamp: DateTime.now(),
        autorId: '',
      );

  factory Observacao.fromJson(Map<String, dynamic> json) =>
      _$ObservacaoFromJson(json);

  factory Observacao.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Observacao.fromJson(data).copyWith(id: doc.id);
  }
}
