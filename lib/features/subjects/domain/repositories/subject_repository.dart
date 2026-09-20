import '../entities/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getSubjects();
  Future<Subject> getSubjectById(String id);
  Future<void> addSubject(Subject subject);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(String id);
}
