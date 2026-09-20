import '../entities/student.dart';
import '../repositories/student_repository.dart';

class UpdateStudent {
  final StudentRepository repository;

  UpdateStudent(this.repository);

  Future<void> execute(Student student) async {
    return await repository.updateStudent(student);
  }
}
