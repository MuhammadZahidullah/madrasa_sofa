import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<List<TeacherModel>> getTeachers();
  Future<TeacherModel> getTeacherById(String id);
  Future<void> addTeacher(TeacherModel teacher);
  Future<void> updateTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(String id);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final FirebaseFirestore firestore;

  TeacherRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TeacherModel>> getTeachers() async {
    final snapshot = await firestore.collection('teachers').get();
    return snapshot.docs.map((doc) => TeacherModel.fromFirestore(doc)).toList();
  }

  @override
  Future<TeacherModel> getTeacherById(String id) async {
    final doc = await firestore.collection('teachers').doc(id).get();
    if (!doc.exists) {
      throw Exception('Teacher not found');
    }
    return TeacherModel.fromFirestore(doc);
  }

  @override
  Future<void> addTeacher(TeacherModel teacher) async {
    final docRef = teacher.id.isEmpty
        ? firestore.collection('teachers').doc()
        : firestore.collection('teachers').doc(teacher.id);
    await docRef.set(teacher.toFirestore());
  }

  @override
  Future<void> updateTeacher(TeacherModel teacher) async {
    await firestore
        .collection('teachers')
        .doc(teacher.id)
        .update(teacher.toFirestore());
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await firestore.collection('teachers').doc(id).delete();
  }
}
