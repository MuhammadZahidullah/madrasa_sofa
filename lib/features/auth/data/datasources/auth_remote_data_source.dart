import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madrasa_soffa/features/auth/data/models/app_user_model.dart';
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('invalid-credentials');
      } else if (e.code == 'invalid-email') {
        throw Exception('invalid-email');
      } else {
        throw Exception('login-failed');
      }
    } catch (e) {
      throw Exception('login-failed');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<AppUserModel?> getUserProfile(String uid) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnapshot = await docRef.get();
      
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return AppUserModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } on FirebaseException {
      throw Exception('profile-fetch-failed');
    } catch (e) {
      throw Exception('profile-fetch-failed');
    }
  }
}
