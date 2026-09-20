import '../entities/student.dart';
import '../repositories/student_repository.dart';

class AddStudent {
  final StudentRepository repository;

  AddStudent(this.repository);

  Future<void> execute(Student student) async {
    return await repository.addStudent(student);
  }
}
