import 'exceptions.dart';
import 'failure.dart';

Failure mapExceptionToFailure(Object exception) {
  return switch (exception) {
    UnauthorizedException() => const UnauthorizedFailure(),
    NetworkException() => const NetworkFailure(),
    ServerException() => const ServerFailure(),
    _ => const UnknownFailure(),
  };
}
