import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teaching_assignment_model.dart';

abstract class TeachingAssignmentRemoteDataSource {
  Future<List<TeachingAssignmentModel>> getAssignmentsByTeacher(String teacherId);
  Future<void> saveTeacherAssignments(String teacherId, List<TeachingAssignmentModel> assignments);
  Future<void> deleteAssignmentsByTeacher(String teacherId);
}

class TeachingAssignmentRemoteDataSourceImpl implements TeachingAssignmentRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath = 'teachingAssignments';

  TeachingAssignmentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TeachingAssignmentModel>> getAssignmentsByTeacher(String teacherId) async {
    try {
      final snapshot = await firestore
          .collection(collectionPath)
          .where('teacherId', isEqualTo: teacherId)
          .get();

      return snapshot.docs
          .map((doc) => TeachingAssignmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch teaching assignments: $e');
    }
  }

  @override
  Future<void> saveTeacherAssignments(String teacherId, List<TeachingAssignmentModel> assignments) async {
    try {
      final batch = firestore.batch();
      final collection = firestore.collection(collectionPath);

      // 1. Delete all existing assignments for this teacher
      final existingSnapshot = await collection
          .where('teacherId', isEqualTo: teacherId)
          .get();

      for (var doc in existingSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. Insert the new assignments
      for (var assignment in assignments) {
        final docRef = collection.doc(); // Generate new ID for each assignment
        batch.set(docRef, assignment.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save teaching assignments: $e');
    }
  }

  @override
  Future<void> deleteAssignmentsByTeacher(String teacherId) async {
    try {
      final batch = firestore.batch();
      final collection = firestore.collection(collectionPath);
      
      final existingSnapshot = await collection
          .where('teacherId', isEqualTo: teacherId)
          .get();

      for (var doc in existingSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete teaching assignments: $e');
    }
  }
}
