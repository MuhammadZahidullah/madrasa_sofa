import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/subject_remote_data_source.dart';
import '../models/subject_model.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remoteDataSource;

  SubjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Subject>> getSubjects() async {
    final subjectModels = await remoteDataSource.getSubjects();
    return List<Subject>.from(subjectModels);
  }

  @override
  Future<Subject> getSubjectById(String id) async {
    return await remoteDataSource.getSubjectById(id);
  }

  @override
  Future<void> addSubject(Subject subject) async {
    final subjectModel = SubjectModel.fromEntity(subject);
    await remoteDataSource.addSubject(subjectModel);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    final subjectModel = SubjectModel.fromEntity(subject);
    await remoteDataSource.updateSubject(subjectModel);
  }

  @override
  Future<void> deleteSubject(String id) async {
    await remoteDataSource.deleteSubject(id);
  }
}
