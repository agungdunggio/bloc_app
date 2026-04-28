import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  });

  Future<ProductModel> getProductDetail(int productId);

  Future<List<ProductModel>> getRecommendations(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts({
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
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
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

  @override
  Future<ProductModel> getProductDetail(int productId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/$productId',
      );
      final data = response.data;
      if (data == null) throw const ServerException('Empty response');
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedException();
      throw const ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getRecommendations(String category) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/category/$category',
      );
      final list = (response.data?['products'] as List<dynamic>?) ?? const [];
      return list
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedException();
      throw const ServerException();
    }
  }
}
