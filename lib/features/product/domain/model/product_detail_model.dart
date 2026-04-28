import 'package:bloc_state_management/features/product/domain/model/product_model.dart';

class ProductDetailModel {
  const ProductDetailModel({
    required this.detail,
    required this.recommendations,
  });

  final ProductModel detail;
  final List<ProductModel> recommendations;
}
