class Student {
  final String id;
  final String name;
  final String fatherName;
  final String classId;
  final String rollNumber;
  final String? phone;
  final String? address;
  final bool isActive;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.classId,
    required this.rollNumber,
    this.phone,
    this.address,
    this.isActive = true,
    required this.createdAt,
  });
}
