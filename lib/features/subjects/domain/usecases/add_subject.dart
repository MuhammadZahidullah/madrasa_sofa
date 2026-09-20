import '../entities/subject.dart';
import '../repositories/subject_repository.dart';

class AddSubject {
  final SubjectRepository repository;

  AddSubject(this.repository);

  Future<void> execute(Subject subject) async {
    return await repository.addSubject(subject);
  }
}
