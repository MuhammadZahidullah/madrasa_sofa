class Subject {
  final String id;
  final String nameEn;
  final String nameUr;
  final String nameAr;
  final bool isActive;
  final DateTime createdAt;

  const Subject({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.nameAr,
    this.isActive = true,
    required this.createdAt,
  });

  Subject copyWith({
    String? id,
    String? nameEn,
    String? nameUr,
    String? nameAr,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Subject(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      nameAr: nameAr ?? this.nameAr,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
