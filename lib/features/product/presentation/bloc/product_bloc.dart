import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

EventTransformer<T> debounceRestartable<T>(Duration duration) {
  return (events, mapper) =>
      restartable<T>().call(events.debounce(duration), mapper);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetProductDetailUseCase getProductDetailUseCase,
    required GetRecommendationsUseCase getRecommendationsUseCase,
    required ProductRepository productRepository,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductDetailUseCase = getProductDetailUseCase,
       _getRecommendationsUseCase = getRecommendationsUseCase,
       _productRepository = productRepository,
       super(const ProductInitial()) {
    on<ProductStarted>(_onStarted, transformer: restartable());
    on<ProductSearchChanged>(
      _onSearchChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<ProductLoadMoreRequested>(
      _onLoadMoreRequested,
      transformer: droppable(),
    );
    on<ProductDetailRequested>(_onDetailRequested, transformer: restartable());
    on<ProductResetRequested>(_onResetRequested, transformer: sequential());
  }

  static const _pageSize = 10;

  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailUseCase _getProductDetailUseCase;
  final GetRecommendationsUseCase _getRecommendationsUseCase;
  final ProductRepository _productRepository;
  ProductStateData get _data => ProductStateData.fromState(state);

  Future<void> _onStarted(
    ProductStarted event,
    Emitter<ProductState> emit,
  ) async {
    final nextData = _data.copyWith(
      isLoadingList: true,
      clearListFailure: true,
      hasReachedMax: false,
      products: const [],
    );
    emit(ProductListLoading.fromData(nextData));
    await _loadProducts(emit: emit, append: false);
  }

  Future<void> _onSearchChanged(
    ProductSearchChanged event,
    Emitter<ProductState> emit,
  ) async {
    final nextData = _data.copyWith(
      query: event.query,
      isLoadingList: true,
      clearListFailure: true,
      hasReachedMax: false,
      products: const [],
    );
    emit(ProductListLoading.fromData(nextData));
    await _loadProducts(emit: emit, append: false);
  }

  Future<void> _onLoadMoreRequested(
    ProductLoadMoreRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore || state.isLoadingList) {
      return;
    }
    final nextData = _data.copyWith(
      isLoadingMore: true,
      clearListFailure: true,
    );
    emit(ProductListLoading.fromData(nextData));
    await _loadProducts(emit: emit, append: true);
  }

  Future<void> _loadProducts({
    required Emitter<ProductState> emit,
    required bool append,
  }) async {
    try {
      final result = await _getProductsUseCase(
        ProductParams(
          limit: _pageSize,
          skip: append ? state.products.length : 0,
          searchQuery: state.query,
        ),
      );
      final merged = append ? [...state.products, ...result] : result;
      final nextData = _data.copyWith(
        products: merged,
        isLoadingList: false,
        isLoadingMore: false,
        hasReachedMax: result.length < _pageSize,
        clearListFailure: true,
      );
      emit(ProductListLoaded.fromData(nextData));
    } catch (e) {
      final nextData = _data.copyWith(
        isLoadingList: false,
        isLoadingMore: false,
        listFailure: _productRepository.mapExceptionToFailure(e),
      );
      emit(ProductListError.fromData(nextData));
    }
  }

  Future<void> _onDetailRequested(
    ProductDetailRequested event,
    Emitter<ProductState> emit,
  ) async {
    final loadingData = _data.copyWith(
      isLoadingDetail: true,
      clearDetailFailure: true,
      selectedProduct: null,
      recommendations: const [],
    );
    emit(ProductDetailLoading.fromData(loadingData));
    try {
      final detail = await _getProductDetailUseCase(event.productId);
      final recommendations = await _getRecommendationsUseCase(
        RecommendationParams(category: detail.category, excludeId: detail.id),
      );
      final nextData = _data.copyWith(
        isLoadingDetail: false,
        selectedProduct: detail,
        recommendations: recommendations.take(10).toList(),
        clearDetailFailure: true,
      );
      emit(ProductDetailLoaded.fromData(nextData));
    } catch (e) {
      final nextData = _data.copyWith(
        isLoadingDetail: false,
        detailFailure: _productRepository.mapExceptionToFailure(e),
      );
      emit(ProductDetailError.fromData(nextData));
    }
  }

  void _onResetRequested(
    ProductResetRequested event,
    Emitter<ProductState> emit,
  ) {
    emit(const ProductInitial());
  }
}
