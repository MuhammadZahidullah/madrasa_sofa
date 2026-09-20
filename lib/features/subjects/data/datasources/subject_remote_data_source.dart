import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';

abstract class SubjectRemoteDataSource {
  Future<List<SubjectModel>> getSubjects();
  Future<SubjectModel> getSubjectById(String id);
  Future<void> addSubject(SubjectModel subject);
  Future<void> updateSubject(SubjectModel subject);
  Future<void> deleteSubject(String id);
}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final FirebaseFirestore firestore;

  SubjectRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SubjectModel>> getSubjects() async {
    final snapshot = await firestore.collection('subjects').get();
    final list =
        snapshot.docs.map((doc) => SubjectModel.fromFirestore(doc)).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<SubjectModel> getSubjectById(String id) async {
    final doc = await firestore.collection('subjects').doc(id).get();
    if (!doc.exists) {
      throw Exception('Subject not found');
    }
    return SubjectModel.fromFirestore(doc);
  }

  @override
  Future<void> addSubject(SubjectModel subject) async {
    final docRef = subject.id.isEmpty
        ? firestore.collection('subjects').doc()
        : firestore.collection('subjects').doc(subject.id);
    await docRef.set(subject.toFirestore());
  }

  @override
  Future<void> updateSubject(SubjectModel subject) async {
    await firestore
        .collection('subjects')
        .doc(subject.id)
        .update(subject.toFirestore());
  }

  @override
  Future<void> deleteSubject(String id) async {
    await firestore.collection('subjects').doc(id).delete();
  }
}
