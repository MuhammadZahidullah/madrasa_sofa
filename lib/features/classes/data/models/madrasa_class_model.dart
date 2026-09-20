import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/madrasa_class.dart';

class MadrasaClassModel extends MadrasaClass {
  MadrasaClassModel({
    required super.id,
    required super.nameEn,
    required super.nameUr,
    required super.nameAr,
    required super.sortOrder,
    super.isActive = true,
    required super.createdAt,
  });

  factory MadrasaClassModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MadrasaClassModel(
      id: doc.id,
      nameEn: data['nameEn'] as String? ?? '',
      nameUr: data['nameUr'] as String? ?? '',
      nameAr: data['nameAr'] as String? ?? '',
      sortOrder: data['sortOrder'] as int? ?? 999,
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
      'sortOrder': sortOrder,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MadrasaClassModel.fromEntity(MadrasaClass entity) {
    return MadrasaClassModel(
      id: entity.id,
      nameEn: entity.nameEn,
      nameUr: entity.nameUr,
      nameAr: entity.nameAr,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
