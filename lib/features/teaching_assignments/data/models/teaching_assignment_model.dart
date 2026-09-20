import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/teaching_assignment.dart';

class TeachingAssignmentModel extends TeachingAssignment {
  TeachingAssignmentModel({
    required super.id,
    required super.teacherId,
    required super.classId,
    required super.subjectId,
    super.isActive = true,
    required super.createdAt,
  });

  factory TeachingAssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeachingAssignmentModel(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      classId: data['classId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': teacherId,
      'classId': classId,
      'subjectId': subjectId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TeachingAssignmentModel.fromEntity(TeachingAssignment entity) {
    return TeachingAssignmentModel(
      id: entity.id,
      teacherId: entity.teacherId,
      classId: entity.classId,
      subjectId: entity.subjectId,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
