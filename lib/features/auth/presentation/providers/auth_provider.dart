import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madrasa_soffa/features/auth/domain/entities/app_user.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/login_user.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/logout_user.dart';
import 'package:madrasa_soffa/features/auth/domain/usecases/get_current_user.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;

  AuthProvider({
    required LoginUser loginUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
  }) : _loginUser = loginUser,
       _logoutUser = logoutUser,
       _getCurrentUser = getCurrentUser;

  bool _isLoading = false;
  String? _errorMessage;
  AppUser? _appUser;
  bool _isProfileLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUser? get appUser => _appUser;
  bool get isProfileLoading => _isProfileLoading;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _loginUser.execute(email, password);
      if (user != null) {
        final success = await fetchProfile(user.uid);
        _setLoading(false);
        return success;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> fetchProfile(String uid) async {
    _isProfileLoading = true;
    notifyListeners();
    try {
      final profile = await _getCurrentUser.execute(uid);
      if (profile == null) {
        _errorMessage = 'profile-not-configured';
        _isProfileLoading = false;
        notifyListeners();
        return false;
      }
      if (!profile.isActive) {
        _errorMessage = 'account-disabled';
        _isProfileLoading = false;
        notifyListeners();
        return false;
      }
      if (profile.role != 'admin' &&
          profile.role != 'teacher' &&
          profile.role != 'student') {
        _errorMessage = 'unknown-role';
        _isProfileLoading = false;
        notifyListeners();
        return false;
      }
      _appUser = profile;
      _isProfileLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'profile-fetch-failed';
      _isProfileLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logoutUser.execute();
    _appUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
