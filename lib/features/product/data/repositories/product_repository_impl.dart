import 'package:bloc_state_management/core/error/error_mapper.dart';
import 'package:bloc_state_management/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';
import 'package:bloc_state_management/features/product/domain/interface/product_repository.dart';
import 'package:bloc_state_management/features/product/data/datasource/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
  }) async {
    try {
      final products = await _remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
        searchQuery: searchQuery,
      );
      return Right(products);
    } catch (exception) {
      return Left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductDetail(int productId) async {
    try {
      final product = await _remoteDataSource.getProductDetail(productId);
      return Right(product);
    } catch (exception) {
      return Left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getRecommendations({
    required String category,
    required int excludeId,
  }) async {
    try {
      final products = await _remoteDataSource.getRecommendations(category);
      return Right(products.where((item) => item.id != excludeId).toList());
    } catch (exception) {
      return Left(mapExceptionToFailure(exception));
    }
  }
}
