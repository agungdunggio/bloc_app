part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class ProductStarted extends ProductEvent {
  const ProductStarted();
}

final class ProductSearchChanged extends ProductEvent {
  const ProductSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ProductLoadMoreRequested extends ProductEvent {
  const ProductLoadMoreRequested();
}

final class ProductDetailRequested extends ProductEvent {
  const ProductDetailRequested(this.productId);

  final int productId;

  @override
  List<Object?> get props => [productId];
}

final class ProductResetRequested extends ProductEvent {
  const ProductResetRequested();
}
