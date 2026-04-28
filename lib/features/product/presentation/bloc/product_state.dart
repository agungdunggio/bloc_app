part of 'product_bloc.dart';

final class ProductState extends Equatable {
  const ProductState({
    this.products = const [],
    this.isLoadingList = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.query = '',
    this.listFailure,
    this.selectedProduct,
    this.recommendations = const [],
    this.isLoadingDetail = false,
    this.detailFailure,
  });

  final List<ProductModel> products;
  final bool isLoadingList;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String query;
  final Failure? listFailure;
  final ProductModel? selectedProduct;
  final List<ProductModel> recommendations;
  final bool isLoadingDetail;
  final Failure? detailFailure;

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoadingList,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? query,
    Failure? listFailure,
    ProductModel? selectedProduct,
    List<ProductModel>? recommendations,
    bool? isLoadingDetail,
    Failure? detailFailure,
    bool clearListFailure = false,
    bool clearDetailFailure = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
      listFailure: clearListFailure ? null : (listFailure ?? this.listFailure),
      selectedProduct: selectedProduct ?? this.selectedProduct,
      recommendations: recommendations ?? this.recommendations,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      detailFailure: clearDetailFailure
          ? null
          : (detailFailure ?? this.detailFailure),
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoadingList,
    isLoadingMore,
    hasReachedMax,
    query,
    listFailure,
    selectedProduct,
    recommendations,
    isLoadingDetail,
    detailFailure,
  ];
}
