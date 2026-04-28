import '../../../../core/error/failure.dart';
import '../model/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Failure mapExceptionToFailure(Object exception);
}
