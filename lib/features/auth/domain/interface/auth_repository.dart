import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/features/auth/domain/model/user_model.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();
}
