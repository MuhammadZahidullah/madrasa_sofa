import '../entities/subject.dart';
import '../repositories/subject_repository.dart';

class GetSubjects {
  final SubjectRepository repository;

  GetSubjects(this.repository);

  Future<List<Subject>> execute() async {
    return await repository.getSubjects();
  }
}
