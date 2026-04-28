import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  });

  Future<Either<Failure, ProductModel>> getProductDetail(int productId);

  Future<Either<Failure, List<ProductModel>>> getRecommendations({
    required String category,
    required int excludeId,
  });
}
