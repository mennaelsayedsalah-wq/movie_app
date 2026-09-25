import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email ?? email,
    );
  }

  Future<AppUser> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email ?? email,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  AppUser? get currentUser {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}