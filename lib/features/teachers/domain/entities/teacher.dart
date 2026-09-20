class Teacher {
  final String id;
  final String name;
  final String fatherName;
  final String? phone;
  final String? address;
  final String? qualification;
  final List<String> assignedClassIds;
  final bool isActive;
  final DateTime createdAt;

  Teacher({
    required this.id,
    required this.name,
    required this.fatherName,
    this.phone,
    this.address,
    this.qualification,
    required this.assignedClassIds,
    this.isActive = true,
    required this.createdAt,
  });
}
