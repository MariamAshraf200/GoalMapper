import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
        debugPrint('🚪 AuthBloc: no user found');
        emit(AuthSignedOut());
      }
    } catch (e, s) {
      debugPrint('❌ AuthBloc: CheckSignInEvent error → $e\n$s');
      emit(AuthError('Failed to check sign-in status.'));
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
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError('Sign out failed.'));
    }
  }

}
