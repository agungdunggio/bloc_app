import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetRecommendationsUseCase
    implements UseCase<List<ProductEntity>, RecommendationParams> {
  const GetRecommendationsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<List<ProductEntity>> call(RecommendationParams params) {
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
