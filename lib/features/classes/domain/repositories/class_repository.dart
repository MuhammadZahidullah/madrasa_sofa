import '../entities/madrasa_class.dart';

abstract class ClassRepository {
  Future<List<MadrasaClass>> getClasses();
  Future<void> addClass(MadrasaClass madrasaClass);
  Future<void> updateClass(MadrasaClass madrasaClass);
  Future<void> deleteClass(String classId);
  Future<void> seedClasses();
  Future<bool> hasStudentsInClass(String classId);
}
