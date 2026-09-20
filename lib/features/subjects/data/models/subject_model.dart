import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/subject.dart';

class SubjectModel extends Subject {
  const SubjectModel({
    required super.id,
    required super.nameEn,
    required super.nameUr,
    required super.nameAr,
    super.isActive = true,
    required super.createdAt,
  });

  factory SubjectModel.fromEntity(Subject subject) {
    return SubjectModel(
      id: subject.id,
      nameEn: subject.nameEn,
      nameUr: subject.nameUr,
      nameAr: subject.nameAr,
      isActive: subject.isActive,
      createdAt: subject.createdAt,
    );
  }

  factory SubjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SubjectModel(
      id: doc.id,
      nameEn: data['nameEn'] as String? ?? '',
      nameUr: data['nameUr'] as String? ?? '',
      nameAr: data['nameAr'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nameEn': nameEn,
      'nameUr': nameUr,
      'nameAr': nameAr,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
