class TeachingAssignment {
  final String id;
  final String teacherId;
  final String classId;
  final String subjectId;
  final bool isActive;
  final DateTime createdAt;

  TeachingAssignment({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
    this.isActive = true,
    required this.createdAt,
  });

  TeachingAssignment copyWith({
    String? id,
    String? teacherId,
    String? classId,
    String? subjectId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return TeachingAssignment(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
