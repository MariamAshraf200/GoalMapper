import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../app_bootstrapper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../screen/auth_screen.dart';
import 'auth_event.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSignedIn extends AuthState {
  final UserEntity user;
  AuthSignedIn(this.user);
}
class AuthSignedOut extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signOut,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<CheckSignInEvent>(_onCheckSignIn);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckSignIn(CheckSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUser();
      if (user != null) {
        debugPrint('✅ AuthBloc: user already signed in → ${user.name}');
        emit(AuthSignedIn(user));
      } else {
        debugPrint('🚪 AuthBloc: no user found → navigating to AuthScreen');
        emit(AuthSignedOut());
        _navigateToAuthScreen();
      }
    } catch (e, s) {
      debugPrint('❌ AuthBloc: CheckSignInEvent error → $e\n$s');
      emit(AuthSignedOut());
      _navigateToAuthScreen();
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signInWithGoogle();
      if (user != null) {
        debugPrint('✅ AuthBloc: Google SignIn success → ${user.name}');
        emit(AuthSignedIn(user));
      } else {
        debugPrint('🚫 AuthBloc: Google SignIn returned null');
        emit(AuthSignedOut());
      }
    } catch (e, s) {
      debugPrint('❌ AuthBloc: SignInEvent error → $e\n$s');
      emit(AuthError('Sign in failed. Please try again.'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signOut();
      debugPrint('👋 AuthBloc: signed out successfully');
      emit(AuthSignedOut());
      _navigateToAuthScreen();
    } catch (e, s) {
      debugPrint('❌ AuthBloc: SignOutEvent error → $e\n$s');
      emit(AuthError('Sign out failed.'));
    }
  }

  void _navigateToAuthScreen() {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    }
  }
}
