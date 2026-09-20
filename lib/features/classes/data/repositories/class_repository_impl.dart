import '../../domain/entities/madrasa_class.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_remote_data_source.dart';
import '../models/madrasa_class_model.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MadrasaClass>> getClasses() async {
    final models = await remoteDataSource.getClasses();
    return List<MadrasaClass>.from(models);
  }

  @override
  Future<void> addClass(MadrasaClass madrasaClass) async {
    final model = MadrasaClassModel.fromEntity(madrasaClass);
    await remoteDataSource.addClass(model);
  }

  @override
  Future<void> updateClass(MadrasaClass madrasaClass) async {
    final model = MadrasaClassModel.fromEntity(madrasaClass);
    await remoteDataSource.updateClass(model);
  }

  @override
  Future<void> deleteClass(String classId) async {
    await remoteDataSource.deleteClass(classId);
  }

  @override
  Future<bool> hasStudentsInClass(String classId) async {
    return await remoteDataSource.hasStudentsInClass(classId);
  }

  @override
  Future<void> seedClasses() async {
    await remoteDataSource.seedClasses();
  }
}
