import 'package:madrasa_soffa/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<void> execute() async {
    await repository.logout();
  }
}
