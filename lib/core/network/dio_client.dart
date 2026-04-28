import 'package:dio/dio.dart';

import 'app_interceptor.dart';
import 'auth_token_provider.dart';

class DioClient {
  DioClient({
    required AuthTokenProvider tokenProvider,
    required VoidCallback onUnauthorized,
  }) : dio =
           Dio(
               BaseOptions(
                 baseUrl: 'https://dummyjson.com',
                 connectTimeout: const Duration(seconds: 15),
                 receiveTimeout: const Duration(seconds: 15),
                 contentType: Headers.jsonContentType,
               ),
             )
             ..interceptors.add(
               AppInterceptor(
                 tokenProvider: tokenProvider,
                 onUnauthorized: onUnauthorized,
               ),
             );

  final Dio dio;
}
