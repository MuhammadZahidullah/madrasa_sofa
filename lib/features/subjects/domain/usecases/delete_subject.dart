import '../repositories/subject_repository.dart';

class DeleteSubject {
  final SubjectRepository repository;

  DeleteSubject(this.repository);

  Future<void> execute(String id) async {
    return await repository.deleteSubject(id);
  }
}
