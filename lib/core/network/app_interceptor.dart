import 'package:dio/dio.dart';

import 'auth_token_provider.dart';

class AppInterceptor extends Interceptor {
  AppInterceptor({
    required AuthTokenProvider tokenProvider,
    required VoidCallback onUnauthorized,
  }) : _tokenProvider = tokenProvider,
       _onUnauthorized = onUnauthorized;

  final AuthTokenProvider _tokenProvider;
  final VoidCallback _onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _onUnauthorized();
    }
    handler.next(err);
  }
}

typedef VoidCallback = void Function();
