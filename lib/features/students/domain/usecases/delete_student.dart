import '../repositories/student_repository.dart';

class DeleteStudent {
  final StudentRepository repository;

  DeleteStudent(this.repository);

  Future<void> execute(String id) async {
    return await repository.deleteStudent(id);
  }
}
