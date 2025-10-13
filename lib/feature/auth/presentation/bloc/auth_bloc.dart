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

  AuthBloc({required this.signInWithGoogle, required this.signOut, required this.getCurrentUser}) : super(AuthInitial()) {
    on<CheckSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await getCurrentUser();
        if (user != null) {
          debugPrint('AuthBloc: emitting AuthSignedIn for user ${user.name}');
          emit(AuthSignedIn(user));
        } else {
          debugPrint('AuthBloc: emitting AuthSignedOut');
          emit(AuthSignedOut());
        }
      } catch (e) {
        debugPrint('AuthBloc: emitting AuthError $e');
        emit(AuthError(e.toString()));
      }
    });
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogle();
        debugPrint('AuthBloc: signInWithGoogle returned user: ${user?.name}, email: ${user?.email}');
        if (user != null) {
          debugPrint('AuthBloc: emitting AuthSignedIn for user ${user.name}');
          emit(AuthSignedIn(user));
        } else {
          debugPrint('AuthBloc: emitting AuthSignedOut (user is null)');
          emit(AuthSignedOut());
        }
      } catch (e) {
        debugPrint('AuthBloc: emitting AuthError $e');
        emit(AuthError(e.toString()));
      }
    });
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOut();
        debugPrint('AuthBloc: emitting AuthSignedOut after sign out');
        emit(AuthSignedOut());

        // Navigate to AuthScreen after signing out
        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        debugPrint('AuthBloc: emitting AuthError $e');
        emit(AuthError(e.toString()));
      }
    });
  }
}
