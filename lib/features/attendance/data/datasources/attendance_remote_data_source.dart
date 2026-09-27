import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attendance.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<AttendanceModel>> getAttendanceForClassAndDate(String classId, String dateKey);
  Future<List<AttendanceModel>> getAttendanceForStudent(String studentId);
  Future<bool> saveAttendanceRecords(List<AttendanceModel> records);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath = 'attendance';

  AttendanceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AttendanceModel>> getAttendanceForClassAndDate(String classId, String dateKey) async {
    try {
      final snapshot = await firestore
          .collection(collectionPath)
          .where('classId', isEqualTo: classId)
          .where('dateKey', isEqualTo: dateKey)
          .get();

      return snapshot.docs
          .map((doc) => AttendanceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance for class and date: $e');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceForStudent(String studentId) async {
    try {
      final snapshot = await firestore
          .collection(collectionPath)
          .where('studentId', isEqualTo: studentId)
          .orderBy('dateKey', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AttendanceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance for student: $e');
    }
  }

  @override
  Future<bool> saveAttendanceRecords(List<AttendanceModel> records) async {
    if (records.isEmpty) return true;

    try {
      final batch = firestore.batch();
      final collection = firestore.collection(collectionPath);

      // Using batch.set() with the deterministic ID.
      // If the record exists, it completely overwrites it.
      // IMPORTANT createdAt Responsibility:
      // The caller (Presentation/Provider layer) MUST pass the existing 
      // Attendance object's createdAt value for existing records, and 
      // explicitly assign DateTime.now() to newly created records.
      // Doing per-record reads here to preserve createdAt would break 
      // offline batching and be unnecessarily expensive.
      for (var record in records) {
        // Enforce deterministic ID generation at the data source layer.
        // This protects against the caller supplying an arbitrary ID.
        final deterministicId = Attendance.generateId(
          classId: record.classId,
          studentId: record.studentId,
          dateKey: record.dateKey,
        );
        
        final docRef = collection.doc(deterministicId);
        
        // Update the updatedAt timestamp right before saving to be safe
        final updatedEntity = record.copyWith(
          id: deterministicId, // Ensure the model uses the correct deterministic ID
          updatedAt: DateTime.now(),
        );
        final updatedModel = AttendanceModel.fromEntity(updatedEntity);
        
        // Use SetOptions(merge: true) to allow partial updates later if needed, 
        // but currently we supply the full object payload.
        batch.set(docRef, updatedModel.toFirestore(), SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to save attendance records: $e');
    }
  }
}
