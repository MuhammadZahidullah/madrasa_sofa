import 'package:firebase_auth/firebase_auth.dart';
import 'package:madrasa_soffa/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<AppUser?> getUserProfile(String uid);
}
