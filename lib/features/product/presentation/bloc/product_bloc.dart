import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/features/product/domain/model/product_model.dart';
import 'package:bloc_state_management/features/product/domain/usecases/get_product_detail_usecase.dart';
import 'package:bloc_state_management/features/product/domain/usecases/get_products_usecase.dart';

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
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductDetailUseCase = getProductDetailUseCase,
       super(const ProductState()) {
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

  Future<void> _onStarted(
    ProductStarted event,
    Emitter<ProductState> emit,
  ) async {
    final nextData = state.copyWith(
      isLoadingList: true,
      clearListFailure: true,
      hasReachedMax: false,
      products: const [],
    );
    emit(nextData);
    await _loadProducts(emit: emit, append: false);
  }

  Future<void> _onSearchChanged(
    ProductSearchChanged event,
    Emitter<ProductState> emit,
  ) async {
    final nextData = state.copyWith(
      query: event.query,
      isLoadingList: true,
      clearListFailure: true,
      hasReachedMax: false,
      products: const [],
    );
    emit(nextData);
    await _loadProducts(emit: emit, append: false);
  }

  Future<void> _onLoadMoreRequested(
    ProductLoadMoreRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore || state.isLoadingList) {
      return;
    }
    final nextData = state.copyWith(
      isLoadingMore: true,
      clearListFailure: true,
    );
    emit(nextData);
    await _loadProducts(emit: emit, append: true);
  }

  Future<void> _loadProducts({
    required Emitter<ProductState> emit,
    required bool append,
  }) async {
    final result = await _getProductsUseCase(
      ProductParams(
        limit: _pageSize,
        skip: append ? state.products.length : 0,
        searchQuery: state.query,
      ),
    );

    result.fold(
      (failure) {
        final nextData = state.copyWith(
          isLoadingList: false,
          isLoadingMore: false,
          listFailure: failure,
        );
        emit(nextData);
      },
      (products) {
        final merged = append ? [...state.products, ...products] : products;
        final nextData = state.copyWith(
          products: merged,
          isLoadingList: false,
          isLoadingMore: false,
          hasReachedMax: products.length < _pageSize,
          clearListFailure: true,
        );
        emit(nextData);
      },
    );
  }

  Future<void> _onDetailRequested(
    ProductDetailRequested event,
    Emitter<ProductState> emit,
  ) async {
    final loadingData = state.copyWith(
      isLoadingDetail: true,
      clearDetailFailure: true,
      selectedProduct: null,
      recommendations: const [],
    );
    emit(loadingData);
    final result = await _getProductDetailUseCase(event.productId);
    result.fold(
      (failure) async {
        final nextData = state.copyWith(
          isLoadingDetail: false,
          detailFailure: failure,
        );
        emit(nextData);
      },
      (detailResult) async {
        final nextData = state.copyWith(
          isLoadingDetail: false,
          selectedProduct: detailResult.detail,
          recommendations: detailResult.recommendations.take(10).toList(),
          clearDetailFailure: true,
        );
        emit(nextData);
      },
    );
  }

  void _onResetRequested(
    ProductResetRequested event,
    Emitter<ProductState> emit,
  ) {
    emit(const ProductState());
  }
}
