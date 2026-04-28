import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase
    implements UseCase<List<ProductEntity>, ProductParams> {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<List<ProductEntity>> call(ProductParams params) {
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
