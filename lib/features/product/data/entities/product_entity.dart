import 'package:bloc_state_management/features/product/domain/model/product_model.dart';

class ProductEntity extends ProductModel {
  const ProductEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.rating,
    required super.thumbnail,
    required super.images,
    required super.category,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      thumbnail: (json['thumbnail'] as String?) ?? '',
      images: ((json['images'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      category: (json['category'] as String?) ?? '',
    );
  }
}
