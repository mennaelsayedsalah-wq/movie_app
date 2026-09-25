import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/auth_controller.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthController controller;

  AuthBloc({
    AuthController? controller,
  })  : controller = controller ?? AuthController(),
        super(AuthInitial()) {
    on<CheckAuth>(_checkAuth);
    on<LoginRequested>(_login);
    on<RegisterRequested>(_register);
    on<LogoutRequested>(_logout);
  }

  void _checkAuth(
    CheckAuth event,
    Emitter<AuthState> emit,
  ) {
    final user = controller.currentUser;

    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _login(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await controller.login(
        event.email,
        event.password,
      );

      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          _getFirebaseError(e.code),
        ),
      );
    } catch (e) {
      emit(
        AuthError(
          'Login failed. Please try again.',
        ),
      );
    }
  }

  Future<void> _register(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await controller.register(
        event.email,
        event.password,
      );

      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          _getFirebaseError(e.code),
        ),
      );
    } catch (e) {
      emit(
        AuthError(
          'Registration failed. Please try again.',
        ),
      );
    }
  }

  Future<void> _logout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await controller.logout();
    emit(Unauthenticated());
  }

  String _getFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}