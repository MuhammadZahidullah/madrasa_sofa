import '../entities/madrasa_class.dart';
import '../repositories/class_repository.dart';

class UpdateClass {
  final ClassRepository repository;

  UpdateClass(this.repository);

  Future<void> call(MadrasaClass madrasaClass) async {
    return await repository.updateClass(madrasaClass);
  }
}
