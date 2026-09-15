import 'package:firebase_auth/firebase_auth.dart';
import 'package:madrasa_soffa/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User?> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}
