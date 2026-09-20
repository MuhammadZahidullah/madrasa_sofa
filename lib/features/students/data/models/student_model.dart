import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.name,
    required super.fatherName,
    required super.classId,
    required super.rollNumber,
    super.phone,
    super.address,
    super.isActive = true,
    required super.createdAt,
  });

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      name: student.name,
      fatherName: student.fatherName,
      classId: student.classId,
      rollNumber: student.rollNumber,
      phone: student.phone,
      address: student.address,
      isActive: student.isActive,
      createdAt: student.createdAt,
    );
  }

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      fatherName: data['fatherName'] as String? ?? '',
      classId: data['classId'] as String? ?? '',
      rollNumber: data['rollNumber'] as String? ?? '',
      phone: data['phone'] as String?,
      address: data['address'] as String?,
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
      'classId': classId,
      'rollNumber': rollNumber,
      'phone': phone,
      'address': address,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
