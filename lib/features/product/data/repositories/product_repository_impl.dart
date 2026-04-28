import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  }) {
    return _remoteDataSource.getProducts(
      limit: limit,
      skip: skip,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<ProductEntity> getProductDetail(int productId) {
    return _remoteDataSource.getProductDetail(productId);
  }

  @override
  Future<List<ProductEntity>> getRecommendations({
    required String category,
    required int excludeId,
  }) async {
    final products = await _remoteDataSource.getRecommendations(category);
    return products.where((item) => item.id != excludeId).toList();
  }

  @override
  Failure mapExceptionToFailure(Object exception) {
    return switch (exception) {
      UnauthorizedException() => const UnauthorizedFailure(),
      NetworkException() => const NetworkFailure(),
      ServerException() => const ServerFailure(),
      _ => const UnknownFailure(),
    };
  }
}
