import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';
import 'package:bloc_state_management/features/product/domain/interface/product_repository.dart';

class GetProductsUseCase
    implements UseCase<Either<Failure, List<ProductModel>>, ProductParams> {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<ProductModel>>> call(ProductParams params) {
    return _repository.getProducts(
      limit: params.limit,
      skip: params.skip,
      searchQuery: params.searchQuery,
    );
  }
}

class ProductParams {
  const ProductParams({
    required this.limit,
    required this.skip,
    this.searchQuery,
  });

  final int limit;
  final int skip;
  final String? searchQuery;
}
