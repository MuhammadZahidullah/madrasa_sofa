class Lesson {
  final int? id;
  final int studentId;
  final String subject;
  final double progress;

  Lesson({
    this.id,
    required this.studentId,
    required this.subject,
    required this.progress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subject': subject,
      'progress': progress,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      studentId: map['studentId'],
      subject: map['subject'],
      progress: map['progress'],
    );
  }
}
