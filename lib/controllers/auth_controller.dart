import '../models/app_user.dart';
import '../services/firebase_service.dart';

class AuthController {
  final FirebaseService service;

  AuthController({FirebaseService? service})
      : service = service ?? FirebaseService();

  Future<AppUser> register(
    String email,
    String password,
  ) {
    return service.register(email, password);
  }

  Future<AppUser> login(
    String email,
    String password,
  ) {
    return service.login(email, password);
  }

  Future<void> logout() {
    return service.logout();
  }

  AppUser? get currentUser {
    return service.currentUser;
  }
}