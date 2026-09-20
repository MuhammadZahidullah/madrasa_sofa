class Attendance {
  final int? id;
  final int studentId;
  final int classId;
  final String date;
  final bool isPresent;

  Attendance({
    this.id,
    required this.studentId,
    required this.classId,
    required this.date,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'date': date,
      'isPresent': isPresent ? 1 : 0,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['studentId'],
      classId: map['classId'],
      date: map['date'],
      isPresent: map['isPresent'] == 1,
    );
  }
}
