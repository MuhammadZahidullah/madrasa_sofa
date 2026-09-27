enum AttendanceStatus {
  present,
  absent,
  leave,
}

class Attendance {
  final String id;
  final String studentId;
  final String classId;
  final String teacherId;
  final String dateKey;
  final AttendanceStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attendance({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.teacherId,
    required this.dateKey,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Attendance copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? teacherId,
    String? dateKey,
    AttendanceStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      dateKey: dateKey ?? this.dateKey,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Generates a deterministic document ID for an attendance record.
  /// The same student + class + date will always resolve to the same ID.
  static String generateId({
    required String classId,
    required String studentId,
    required String dateKey,
  }) {
    return '${classId}_${studentId}_$dateKey';
  }
}
