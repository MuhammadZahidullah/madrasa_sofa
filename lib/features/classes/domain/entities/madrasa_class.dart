class MadrasaClass {
  final String id;
  final String nameEn;
  final String nameUr;
  final String nameAr;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;

  MadrasaClass({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.nameAr,
    required this.sortOrder,
    this.isActive = true,
    required this.createdAt,
  });
}
