import '../entities/madrasa_class.dart';
import '../repositories/class_repository.dart';

class AddClass {
  final ClassRepository repository;

  AddClass(this.repository);

  Future<void> call(MadrasaClass madrasaClass) async {
    return await repository.addClass(madrasaClass);
  }
}
