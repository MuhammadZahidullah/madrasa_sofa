import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/madrasa_class_model.dart';

abstract class ClassRemoteDataSource {
  Future<List<MadrasaClassModel>> getClasses();
  Future<void> addClass(MadrasaClassModel classModel);
  Future<void> updateClass(MadrasaClassModel classModel);
  Future<void> deleteClass(String classId);
  Future<void> seedClasses();
  Future<bool> hasStudentsInClass(String classId);
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final FirebaseFirestore firestore;

  ClassRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<MadrasaClassModel>> getClasses() async {
    final snapshot = await firestore
        .collection('classes')
        .orderBy('sortOrder')
        .get();

    return snapshot.docs
        .map((doc) => MadrasaClassModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> addClass(MadrasaClassModel classModel) async {
    final docRef = classModel.id.isEmpty
        ? firestore.collection('classes').doc()
        : firestore.collection('classes').doc(classModel.id);
    await docRef.set(classModel.toFirestore());
  }

  @override
  Future<void> updateClass(MadrasaClassModel classModel) async {
    await firestore
        .collection('classes')
        .doc(classModel.id)
        .update(classModel.toFirestore());
  }

  @override
  Future<void> deleteClass(String classId) async {
    await firestore.collection('classes').doc(classId).delete();
  }

  @override
  Future<bool> hasStudentsInClass(String classId) async {
    final snapshot = await firestore
        .collection('students')
        .where('classId', isEqualTo: classId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> seedClasses() async {
    final snapshot = await firestore.collection('classes').doc('class_1').get();
    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data['nameAr'] == 'الدرجة الأولى') {
        return; // Already seeded and updated
      }
    }

    final batch = firestore.batch();

    final defaultClasses = [
      {
        'id': 'class_1',
        'nameEn': 'Class 1st',
        'nameUr': 'درجہ اول',
        'nameAr': 'الدرجة الأولى',
        'sortOrder': 1,
      },
      {
        'id': 'class_2',
        'nameEn': 'Class 2nd',
        'nameUr': 'درجہ دوم',
        'nameAr': 'الدرجة الثانية',
        'sortOrder': 2,
      },
      {
        'id': 'class_3',
        'nameEn': 'Class 3rd',
        'nameUr': 'درجہ سوم',
        'nameAr': 'الدرجة الثالثة',
        'sortOrder': 3,
      },
      {
        'id': 'class_4',
        'nameEn': 'Class 4th',
        'nameUr': 'درجہ چہارم',
        'nameAr': 'الدرجة الرابعة',
        'sortOrder': 4,
      },
      {
        'id': 'class_5',
        'nameEn': 'Class 5th',
        'nameUr': 'درجہ پنجم',
        'nameAr': 'الدرجة الخامسة',
        'sortOrder': 5,
      },
      {
        'id': 'class_6',
        'nameEn': 'Class 6th',
        'nameUr': 'درجہ ششم',
        'nameAr': 'الدرجة السادسة',
        'sortOrder': 6,
      },
      {
        'id': 'class_7',
        'nameEn': 'Class 7th',
        'nameUr': 'درجہ ہفتم',
        'nameAr': 'الدرجة السابعة',
        'sortOrder': 7,
      },
      {
        'id': 'class_8',
        'nameEn': 'Class 8th',
        'nameUr': 'درجہ ہشتم',
        'nameAr': 'الدرجة الثامنة',
        'sortOrder': 8,
      },
    ];

    for (final cls in defaultClasses) {
      final docRef = firestore.collection('classes').doc(cls['id'] as String);
      batch.set(
        docRef,
        {
          'nameEn': cls['nameEn'],
          'nameUr': cls['nameUr'],
          'nameAr': cls['nameAr'],
          'sortOrder': cls['sortOrder'],
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }
}
