import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/error/error_mapper.dart';
import 'package:bloc_state_management/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:bloc_state_management/features/auth/data/entities/user_entity.dart';
import 'package:bloc_state_management/features/auth/domain/interface/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      return Right(user);
    } catch (exception) {
      return Left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async => const Right(unit);
}
