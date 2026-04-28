part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  List<ProductEntity> get products;
  bool get isLoadingList;
  bool get isLoadingMore;
  bool get hasReachedMax;
  String get query;
  Failure? get listFailure;
  ProductEntity? get selectedProduct;
  List<ProductEntity> get recommendations;
  bool get isLoadingDetail;
  Failure? get detailFailure;

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoadingList,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? query,
    Failure? listFailure,
    ProductEntity? selectedProduct,
    List<ProductEntity>? recommendations,
    bool? isLoadingDetail,
    Failure? detailFailure,
    bool clearListFailure = false,
    bool clearDetailFailure = false,
  });
}

class ProductStateData extends ProductState {
  const ProductStateData({
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

  factory ProductStateData.fromState(ProductState state) {
    return ProductStateData(
      products: state.products,
      isLoadingList: state.isLoadingList,
      isLoadingMore: state.isLoadingMore,
      hasReachedMax: state.hasReachedMax,
      query: state.query,
      listFailure: state.listFailure,
      selectedProduct: state.selectedProduct,
      recommendations: state.recommendations,
      isLoadingDetail: state.isLoadingDetail,
      detailFailure: state.detailFailure,
    );
  }

  @override
  final List<ProductEntity> products;
  @override
  final bool isLoadingList;
  @override
  final bool isLoadingMore;
  @override
  final bool hasReachedMax;
  @override
  final String query;
  @override
  final Failure? listFailure;
  @override
  final ProductEntity? selectedProduct;
  @override
  final List<ProductEntity> recommendations;
  @override
  final bool isLoadingDetail;
  @override
  final Failure? detailFailure;

  @override
  ProductStateData copyWith({
    List<ProductEntity>? products,
    bool? isLoadingList,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? query,
    Failure? listFailure,
    ProductEntity? selectedProduct,
    List<ProductEntity>? recommendations,
    bool? isLoadingDetail,
    Failure? detailFailure,
    bool clearListFailure = false,
    bool clearDetailFailure = false,
  }) {
    return ProductStateData(
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

final class ProductInitial extends ProductStateData {
  const ProductInitial();
}

final class ProductListLoading extends ProductStateData {
  const ProductListLoading({
    required super.products,
    required super.hasReachedMax,
    required super.query,
    required super.selectedProduct,
    required super.recommendations,
    required super.detailFailure,
    required super.isLoadingDetail,
    super.isLoadingMore = false,
    super.listFailure,
  }) : super(isLoadingList: true);

  factory ProductListLoading.fromData(ProductStateData data) {
    return ProductListLoading(
      products: data.products,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      listFailure: data.listFailure,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
      isLoadingDetail: data.isLoadingDetail,
      detailFailure: data.detailFailure,
    );
  }
}

final class ProductListLoaded extends ProductStateData {
  const ProductListLoaded({
    required super.products,
    required super.isLoadingMore,
    required super.hasReachedMax,
    required super.query,
    required super.selectedProduct,
    required super.recommendations,
    required super.isLoadingDetail,
    required super.detailFailure,
  }) : super(isLoadingList: false, listFailure: null);

  factory ProductListLoaded.fromData(ProductStateData data) {
    return ProductListLoaded(
      products: data.products,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
      isLoadingDetail: data.isLoadingDetail,
      detailFailure: data.detailFailure,
    );
  }
}

final class ProductListError extends ProductStateData {
  const ProductListError({
    required super.products,
    required super.isLoadingMore,
    required super.hasReachedMax,
    required super.query,
    required super.listFailure,
    required super.selectedProduct,
    required super.recommendations,
    required super.isLoadingDetail,
    required super.detailFailure,
  }) : super(isLoadingList: false);

  factory ProductListError.fromData(ProductStateData data) {
    return ProductListError(
      products: data.products,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      listFailure: data.listFailure,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
      isLoadingDetail: data.isLoadingDetail,
      detailFailure: data.detailFailure,
    );
  }
}

final class ProductDetailLoading extends ProductStateData {
  const ProductDetailLoading({
    required super.products,
    required super.isLoadingList,
    required super.isLoadingMore,
    required super.hasReachedMax,
    required super.query,
    required super.listFailure,
    super.selectedProduct,
    super.recommendations = const [],
  }) : super(isLoadingDetail: true);

  factory ProductDetailLoading.fromData(ProductStateData data) {
    return ProductDetailLoading(
      products: data.products,
      isLoadingList: data.isLoadingList,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      listFailure: data.listFailure,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
    );
  }
}

final class ProductDetailLoaded extends ProductStateData {
  const ProductDetailLoaded({
    required super.products,
    required super.isLoadingList,
    required super.isLoadingMore,
    required super.hasReachedMax,
    required super.query,
    required super.listFailure,
    required super.selectedProduct,
    required super.recommendations,
  }) : super(isLoadingDetail: false, detailFailure: null);

  factory ProductDetailLoaded.fromData(ProductStateData data) {
    return ProductDetailLoaded(
      products: data.products,
      isLoadingList: data.isLoadingList,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      listFailure: data.listFailure,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
    );
  }
}

final class ProductDetailError extends ProductStateData {
  const ProductDetailError({
    required super.products,
    required super.isLoadingList,
    required super.isLoadingMore,
    required super.hasReachedMax,
    required super.query,
    required super.listFailure,
    required super.selectedProduct,
    required super.recommendations,
    required super.detailFailure,
  }) : super(isLoadingDetail: false);

  factory ProductDetailError.fromData(ProductStateData data) {
    return ProductDetailError(
      products: data.products,
      isLoadingList: data.isLoadingList,
      isLoadingMore: data.isLoadingMore,
      hasReachedMax: data.hasReachedMax,
      query: data.query,
      listFailure: data.listFailure,
      selectedProduct: data.selectedProduct,
      recommendations: data.recommendations,
      detailFailure: data.detailFailure,
    );
  }
}
