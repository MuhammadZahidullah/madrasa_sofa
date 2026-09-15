import 'package:firebase_auth/firebase_auth.dart';
import 'package:madrasa_soffa/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:madrasa_soffa/features/auth/domain/entities/app_user.dart';
import 'package:madrasa_soffa/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<AppUser?> getUserProfile(String uid) {
    return remoteDataSource.getUserProfile(uid);
  }
}
