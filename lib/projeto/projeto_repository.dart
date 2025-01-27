import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/firestore_provider.dart';
import 'package:viveira/projeto/projeto.dart';

part 'projeto_repository.g.dart';

class ProjetoRepository {
  final FirebaseFirestore _firestore;

  ProjetoRepository(this._firestore);

  Future<Projeto?> findById(String id) async {
    final snapshot = await _firestore.collection('projetos').doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Projeto.fromDocument(snapshot);
  }

  Future<List<Projeto>> find() async {
    final snapshot = await _firestore.collection('projetos').get();
    return snapshot.docs.map((doc) => Projeto.fromDocument(doc)).toList();
  }

  Future<Projeto> insert(Projeto projeto) async {
    final projetoData = projeto.toJson()..remove('id');
    final docRef = await _firestore.collection('projetos').add(projetoData);
    return projeto.copyWith(id: docRef.id);
  }

  Future<void> update(String id, Projeto projeto) async {
    final projetoData = projeto.toJson()..remove('id');
    await _firestore.collection('projetos').doc(projeto.id).update(projetoData);
  }

  Future<void> delete(String id) async {
    await _firestore.collection('projetos').doc(id).delete();
  }
}

@riverpod
ProjetoRepository projetoRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ProjetoRepository(firestore);
}
