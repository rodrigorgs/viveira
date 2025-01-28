import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/firestore_provider.dart';
import 'package:viveira/observacao/observacao.dart';

part 'observacao_repository.g.dart';

class ObservacaoRepository {
  final FirebaseFirestore _firestore;

  ObservacaoRepository(this._firestore);

  Future<Observacao?> findById(String id) async {
    final snapshot = await _firestore.collection('observacoes').doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Observacao.fromDocument(snapshot);
  }

  Future<List<Observacao>> find() async {
    final snapshot = await _firestore
        .collection('observacoes')
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => Observacao.fromDocument(doc)).toList();
  }

  Future<Observacao> insert(Observacao observacao) async {
    final observacaoData = observacao.toJson()..remove('id');
    final docRef =
        await _firestore.collection('observacoes').add(observacaoData);
    return observacao.copyWith(id: docRef.id);
  }

  Future<void> update(String id, Observacao observacao) async {
    final observacaoData = observacao.toJson()..remove('id');
    await _firestore
        .collection('observacoes')
        .doc(observacao.id)
        .update(observacaoData);
  }

  Future<void> delete(String id) async {
    await _firestore.collection('observacoes').doc(id).delete();
  }
}

@riverpod
ObservacaoRepository observacaoRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ObservacaoRepository(firestore);
}
