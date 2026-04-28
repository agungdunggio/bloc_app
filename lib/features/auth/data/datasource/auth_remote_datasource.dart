import 'package:dio/dio.dart';

import 'package:bloc_state_management/core/error/exceptions.dart';
import 'package:bloc_state_management/features/auth/data/entities/user_entity.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserEntity> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username, 'password': password, 'expiresInMins': 30},
      );
      final data = response.data;
      if (data == null) throw const ServerException('Empty response');
      return UserEntity.fromJson(data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      throw const ServerException();
    }
  }
}
