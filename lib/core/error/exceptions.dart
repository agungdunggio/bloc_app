sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server exception']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network exception']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized exception']);
}
