import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

abstract interface class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  });

  Future<ProductEntity> getProductDetail(int productId);

  Future<List<ProductEntity>> getRecommendations({
    required String category,
    required int excludeId,
  });

  Failure mapExceptionToFailure(Object exception);
}
