import '../entities/madrasa_class.dart';
import '../repositories/class_repository.dart';

class GetClasses {
  final ClassRepository repository;

  GetClasses(this.repository);

  Future<List<MadrasaClass>> call() async {
    return await repository.getClasses();
  }
}
