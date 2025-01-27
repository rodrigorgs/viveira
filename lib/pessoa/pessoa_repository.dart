import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viveira/firestore_provider.dart';
import 'package:viveira/pessoa/pessoa.dart';

part 'pessoa_repository.g.dart';

class PessoaRepository {
  final FirebaseFirestore _firestore;

  PessoaRepository(this._firestore);

  Future<Pessoa?> findById(String id) async {
    final snapshot = await _firestore.collection('pessoas').doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Pessoa.fromDocument(snapshot);
  }

  Future<List<Pessoa>> find() async {
    final snapshot = await _firestore.collection('pessoas').get();
    return snapshot.docs.map((doc) => Pessoa.fromDocument(doc)).toList();
  }

  Future<Pessoa> insert(Pessoa pessoa) async {
    final pessoaData = pessoa.toJson()..remove('id');
    final docRef = await _firestore.collection('pessoas').add(pessoaData);
    return pessoa.copyWith(id: docRef.id);
  }

  Future<void> update(String id, Pessoa pessoa) async {
    final pessoaData = pessoa.toJson()..remove('id');
    await _firestore.collection('pessoas').doc(pessoa.id).update(pessoaData);
  }

  Future<void> delete(String id) async {
    await _firestore.collection('pessoas').doc(id).delete();
  }
}

@riverpod
PessoaRepository pessoaRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return PessoaRepository(firestore);
}
