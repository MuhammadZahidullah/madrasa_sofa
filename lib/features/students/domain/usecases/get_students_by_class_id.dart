import '../entities/student.dart';
import '../repositories/student_repository.dart';

class GetStudentsByClassId {
  final StudentRepository repository;

  GetStudentsByClassId(this.repository);

  Future<List<Student>> execute(String classId) async {
    return await repository.getStudentsByClassId(classId);
  }
}
