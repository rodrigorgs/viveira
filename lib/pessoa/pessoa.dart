import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pessoa.freezed.dart';
part 'pessoa.g.dart';

@freezed
class Pessoa with _$Pessoa {
  const factory Pessoa({
    String? id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _Pessoa;

  factory Pessoa.empty() => const Pessoa(
        id: null,
        title: '',
      );

  factory Pessoa.fromJson(Map<String, dynamic> json) => _$PessoaFromJson(json);

  factory Pessoa.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pessoa.fromJson(data).copyWith(id: doc.id);
  }
}
