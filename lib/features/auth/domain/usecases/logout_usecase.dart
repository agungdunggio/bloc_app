import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/auth/domain/interface/auth_repository.dart';

class LogoutUseCase implements UseCase<Either<Failure, Unit>, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => _repository.logout();
}
