import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_remote_data_source.dart';
import '../models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Teacher>> getTeachers() async {
    final teacherModels = await remoteDataSource.getTeachers();
    return List<Teacher>.from(teacherModels);
  }

  @override
  Future<Teacher> getTeacherById(String id) async {
    return await remoteDataSource.getTeacherById(id);
  }

  @override
  Future<void> addTeacher(Teacher teacher) async {
    final teacherModel = TeacherModel.fromEntity(teacher);
    await remoteDataSource.addTeacher(teacherModel);
  }

  @override
  Future<void> updateTeacher(Teacher teacher) async {
    final teacherModel = TeacherModel.fromEntity(teacher);
    await remoteDataSource.updateTeacher(teacherModel);
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await remoteDataSource.deleteTeacher(id);
  }
}
