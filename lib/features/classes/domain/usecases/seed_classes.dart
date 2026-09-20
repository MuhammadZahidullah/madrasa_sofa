import '../repositories/class_repository.dart';

class SeedClasses {
  final ClassRepository repository;

  SeedClasses(this.repository);

  Future<void> call() async {
    return await repository.seedClasses();
  }
}
