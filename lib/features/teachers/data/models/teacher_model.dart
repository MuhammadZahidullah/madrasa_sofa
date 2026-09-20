import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/teacher.dart';

class TeacherModel extends Teacher {
  TeacherModel({
    required super.id,
    required super.name,
    required super.fatherName,
    super.phone,
    super.address,
    super.qualification,
    required super.assignedClassIds,
    super.isActive = true,
    required super.createdAt,
  });

  factory TeacherModel.fromEntity(Teacher teacher) {
    return TeacherModel(
      id: teacher.id,
      name: teacher.name,
      fatherName: teacher.fatherName,
      phone: teacher.phone,
      address: teacher.address,
      qualification: teacher.qualification,
      assignedClassIds: List<String>.from(teacher.assignedClassIds),
      isActive: teacher.isActive,
      createdAt: teacher.createdAt,
    );
  }

  factory TeacherModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TeacherModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      fatherName: data['fatherName'] as String? ?? '',
      phone: data['phone'] as String?,
      address: data['address'] as String?,
      qualification: data['qualification'] as String?,
      assignedClassIds: (data['assignedClassIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      isActive: data['isActive'] as bool? ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'fatherName': fatherName,
      'phone': phone,
      'address': address,
      'qualification': qualification,
      'assignedClassIds': assignedClassIds,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
