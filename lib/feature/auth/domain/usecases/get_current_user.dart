import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}
