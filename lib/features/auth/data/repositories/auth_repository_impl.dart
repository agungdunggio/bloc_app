import 'package:bloc_state_management/core/error/exceptions.dart';
import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:bloc_state_management/features/auth/domain/model/user_model.dart';
import 'package:bloc_state_management/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) {
    return _remoteDataSource.login(username: username, password: password);
  }

  @override
  Future<void> logout() async {
    
  }

  @override
  Failure mapExceptionToFailure(Object exception) {
    return switch (exception) {
      UnauthorizedException() => const UnauthorizedFailure(),
      NetworkException() => const NetworkFailure(),
      ServerException() => const ServerFailure(),
      _ => const UnknownFailure(),
    };
  }
}
