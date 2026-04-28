import '../../../../core/usecase/usecase.dart';
import '../model/user_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserModel, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<UserModel> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParams {
  const LoginParams({required this.username, required this.password});

  final String username;
  final String password;
}
