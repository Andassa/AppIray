import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/profile/domain/user_entity.dart';

/// Contrat du repository utilisateur (domaine).
abstract interface class UsersRepository {
  Future<Result<User>> getMe();
  Future<Result<User>> updateUsername(String username);
}
