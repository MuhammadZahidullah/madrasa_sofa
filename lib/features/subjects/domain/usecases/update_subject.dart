import '../entities/subject.dart';
import '../repositories/subject_repository.dart';

class UpdateSubject {
  final SubjectRepository repository;

  UpdateSubject(this.repository);

  Future<void> execute(Subject subject) async {
    return await repository.updateSubject(subject);
  }
}
