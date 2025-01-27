import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'projeto.freezed.dart';
part 'projeto.g.dart';

@freezed
class Projeto with _$Projeto {
  const factory Projeto({
    String? id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _Projeto;

  factory Projeto.empty() => const Projeto(
        id: null,
        title: '',
      );

  factory Projeto.fromJson(Map<String, dynamic> json) => _$ProjetoFromJson(json);

  factory Projeto.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Projeto.fromJson(data).copyWith(id: doc.id);
  }
}
