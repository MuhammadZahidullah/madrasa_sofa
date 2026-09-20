import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getStudents();
  Future<StudentModel> getStudentById(String id);
  Future<void> addStudent(StudentModel student);
  Future<void> updateStudent(StudentModel student);
  Future<void> deleteStudent(String id);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final FirebaseFirestore firestore;

  StudentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<StudentModel>> getStudents() async {
    final snapshot = await firestore.collection('students').get();
    return snapshot.docs.map((doc) => StudentModel.fromFirestore(doc)).toList();
  }

  @override
  Future<StudentModel> getStudentById(String id) async {
    final doc = await firestore.collection('students').doc(id).get();
    if (!doc.exists) {
      throw Exception('Student not found');
    }
    return StudentModel.fromFirestore(doc);
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    final docRef = student.id.isEmpty
        ? firestore.collection('students').doc()
        : firestore.collection('students').doc(student.id);
    await docRef.set(student.toFirestore());
  }

  @override
  Future<void> updateStudent(StudentModel student) async {
    await firestore
        .collection('students')
        .doc(student.id)
        .update(student.toFirestore());
  }

  @override
  Future<void> deleteStudent(String id) async {
    await firestore.collection('students').doc(id).delete();
  }
}
