import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.id,
    required super.studentId,
    required super.classId,
    required super.teacherId,
    required super.dateKey,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Generates a deterministic document ID for an attendance record.
  /// The same student + class + date will always resolve to the same ID.
  static String generateId({
    required String classId,
    required String studentId,
    required String dateKey,
  }) {
    return '${classId}_${studentId}_$dateKey';
  }

  factory AttendanceModel.fromEntity(Attendance entity) {
    return AttendanceModel(
      id: entity.id,
      studentId: entity.studentId,
      classId: entity.classId,
      teacherId: entity.teacherId,
      dateKey: entity.dateKey,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AttendanceModel(
      id: doc.id,
      studentId: data['studentId'] as String? ?? '',
      classId: data['classId'] as String? ?? '',
      teacherId: data['teacherId'] as String? ?? '',
      dateKey: data['dateKey'] as String? ?? '',
      status: _parseStatus(data['status'] as String?),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'classId': classId,
      'teacherId': teacherId,
      'dateKey': dateKey,
      'status': status.name.toLowerCase(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static AttendanceStatus _parseStatus(String? statusStr) {
    if (statusStr == null) {
      throw FormatException('Attendance status cannot be null.');
    }
    switch (statusStr.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'leave':
        return AttendanceStatus.leave;
      default:
        throw FormatException('Invalid or unsupported attendance status: $statusStr');
    }
  }
}
