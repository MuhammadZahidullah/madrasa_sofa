import 'package:madrasa_soffa/features/auth/domain/entities/app_user.dart';
import 'package:madrasa_soffa/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<AppUser?> execute(String uid) {
    return repository.getUserProfile(uid);
  }
}
