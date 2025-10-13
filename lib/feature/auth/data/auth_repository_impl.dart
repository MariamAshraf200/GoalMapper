import 'package:google_sign_in/google_sign_in.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    return UserEntity(
      id: account!.id,
      name: account.displayName ?? '',
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final account = await _googleSignIn.signInSilently();
    return UserEntity(
      id: account!.id,
      name: account.displayName ?? '',
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }
}
