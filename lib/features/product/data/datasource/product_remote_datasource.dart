import 'package:dio/dio.dart';

import 'package:bloc_state_management/core/error/exceptions.dart';
import 'package:bloc_state_management/features/product/data/entities/product_entity.dart';

class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  }) async {
    try {
      final endpoint = (searchQuery != null && searchQuery.isNotEmpty)
          ? '/products/search'
          : '/products';
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: {
          'limit': limit,
          'skip': skip,
          if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
        },
      );
      final list = (response.data?['products'] as List<dynamic>?) ?? const [];
      return list
          .map((item) => ProductEntity.fromJson(item as Map<String, dynamic>))
          .toList();
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

  Future<ProductEntity> getProductDetail(int productId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/$productId',
      );
      final data = response.data;
      if (data == null) throw const ServerException('Empty response');
      return ProductEntity.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedException();
      throw const ServerException();
    }
  }

  Future<List<ProductEntity>> getRecommendations(String category) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/category/$category',
      );
      final list = (response.data?['products'] as List<dynamic>?) ?? const [];
      return list
          .map((item) => ProductEntity.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedException();
      throw const ServerException();
    }
  }
}
