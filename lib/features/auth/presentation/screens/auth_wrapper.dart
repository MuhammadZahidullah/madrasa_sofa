import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/features/auth/presentation/providers/auth_provider.dart';
import 'package:madrasa_soffa/features/auth/presentation/screens/login_screen.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/screens/admin_dashboard.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/screens/teacher_dashboard.dart';
import 'package:madrasa_soffa/features/dashboard/presentation/screens/student_dashboard.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).fetchProfile(user.uid);
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // User is authenticated in Firebase Auth.
          // Now check the AuthProvider for the loaded profile.
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isProfileLoading ||
                  authProvider.appUser == null) {
                if (authProvider.errorMessage != null) {
                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getLocalizedErrorMessage(
                                context,
                                authProvider.errorMessage!,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => authProvider.logout(),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final role = authProvider.appUser!.role;
              if (role == 'admin') {
                return const AdminDashboard();
              } else if (role == 'teacher') {
                return const TeacherDashboard();
              } else if (role == 'student') {
                return const StudentDashboard();
              }

              return const Scaffold(body: Center(child: Text('Unknown role')));
            },
          );
        }

        return const LoginScreen();
      },
    );
  }

  String _getLocalizedErrorMessage(BuildContext context, String errorCode) {
    final l10n = AppLocalizations.of(context)!;
    if (errorCode == 'profile-not-configured') {
      return l10n.accountNotConfigured;
    } else if (errorCode == 'account-disabled') {
      return l10n.accountDisabled;
    } else if (errorCode == 'unknown-role') {
      return l10n.unknownRole;
    } else if (errorCode == 'profile-fetch-failed') {
      return l10n.profileFetchFailed;
    }
    return errorCode;
  }
}
