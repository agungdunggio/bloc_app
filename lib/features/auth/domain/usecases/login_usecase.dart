import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/auth/domain/model/user_model.dart';
import 'package:bloc_state_management/features/auth/domain/interface/auth_repository.dart';

class LoginUseCase implements UseCase<Either<Failure, UserModel>, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserModel>> call(LoginParams params) {
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
