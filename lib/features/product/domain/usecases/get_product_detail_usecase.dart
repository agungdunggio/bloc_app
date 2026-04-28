import 'package:bloc_state_management/features/product/domain/model/product_detail_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/product/domain/interface/product_repository.dart';

class GetProductDetailUseCase
    implements UseCase<Either<Failure, ProductDetailModel>, int> {
  const GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductDetailModel>> call(int params) async {
    final detailResult = await _repository.getProductDetail(params);
    if (detailResult.isLeft()) {
      return Left(detailResult.getLeft().toNullable()!);
    }

    final detail = detailResult.getRight().toNullable()!;
    final recommendationsResult = await _repository.getRecommendations(
      category: detail.category,
      excludeId: detail.id,
    );
    return recommendationsResult.fold(
      Left.new,
      (recommendations) => Right(
        ProductDetailModel(detail: detail, recommendations: recommendations),
      ),
    );
  }
}