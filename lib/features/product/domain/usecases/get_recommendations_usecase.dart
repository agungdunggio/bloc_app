import 'package:fpdart/fpdart.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';
import 'package:bloc_state_management/features/product/domain/interface/product_repository.dart';

class GetRecommendationsUseCase
    implements
        UseCase<Either<Failure, List<ProductModel>>, RecommendationParams> {
  const GetRecommendationsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<ProductModel>>> call(
    RecommendationParams params,
  ) {
    return _repository.getRecommendations(
      category: params.category,
      excludeId: params.excludeId,
    );
  }
}

class RecommendationParams {
  const RecommendationParams({required this.category, required this.excludeId});

  final String category;
  final int excludeId;
}
