import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';
import 'package:bloc_state_management/features/product/domain/interface/product_repository.dart';

class GetProductDetailUseCase
    implements UseCase<Either<Failure, ProductModel>, int> {
  const GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductModel>> call(int params) {
    return _repository.getProductDetail(params);
  }
}
