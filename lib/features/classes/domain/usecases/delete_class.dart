import '../repositories/class_repository.dart';

class DeleteClass {
  final ClassRepository repository;

  DeleteClass(this.repository);

  Future<void> call(String classId) async {
    return await repository.deleteClass(classId);
  }
}
