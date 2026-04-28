import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase implements UseCase<ProductEntity, int> {
  const GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<ProductEntity> call(int params) {
    return _repository.getProductDetail(params);
  }
}
