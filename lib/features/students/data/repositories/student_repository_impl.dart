import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_data_source.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Student>> getStudents() async {
    final studentModels = await remoteDataSource.getStudents();
    return List<Student>.from(studentModels);
  }

  @override
  Future<Student> getStudentById(String id) async {
    return await remoteDataSource.getStudentById(id);
  }

  @override
  Future<void> addStudent(Student student) async {
    final studentModel = StudentModel.fromEntity(student);
    await remoteDataSource.addStudent(studentModel);
  }

  @override
  Future<void> updateStudent(Student student) async {
    final studentModel = StudentModel.fromEntity(student);
    await remoteDataSource.updateStudent(studentModel);
  }

  @override
  Future<void> deleteStudent(String id) async {
    await remoteDataSource.deleteStudent(id);
  }
}
