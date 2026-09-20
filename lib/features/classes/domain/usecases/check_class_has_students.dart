import '../repositories/class_repository.dart';

class CheckClassHasStudents {
  final ClassRepository repository;

  CheckClassHasStudents(this.repository);

  Future<bool> call(String classId) async {
    return await repository.hasStudentsInClass(classId);
  }
}
