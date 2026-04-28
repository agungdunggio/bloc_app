import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/auth_token_provider.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/interface/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/product/data/datasource/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/interface/product_repository.dart';
import 'features/product/domain/usecases/get_product_detail_usecase.dart';
import 'features/product/domain/usecases/get_products_usecase.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  if (sl.isRegistered<AuthBloc>()) return;

  sl
    ..registerLazySingleton<AppAuthTokenProvider>(AppAuthTokenProvider.new)
    ..registerLazySingleton<AuthTokenProvider>(() => sl<AppAuthTokenProvider>())
    ..registerLazySingleton<Dio>(
      () => DioClient(
        tokenProvider: sl<AuthTokenProvider>(),
        onUnauthorized: () => sl<AuthBloc>().add(const AuthLogoutRequested()),
      ).dio,
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl<Dio>()),
    )
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSource(sl<Dio>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
    )
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(sl<ProductRepository>()),
    )
    ..registerLazySingleton<GetProductDetailUseCase>(
      () => GetProductDetailUseCase(sl<ProductRepository>()),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
      ),
    )
    ..registerLazySingleton<ProductBloc>(
      () => ProductBloc(
        getProductsUseCase: sl<GetProductsUseCase>(),
        getProductDetailUseCase: sl<GetProductDetailUseCase>(),
      ),
    );

  sl<AppAuthTokenProvider>().attach(sl<AuthBloc>());
}

class AppAuthTokenProvider implements AuthTokenProvider {
  AuthBloc? _authBloc;

  void attach(AuthBloc authBloc) {
    _authBloc = authBloc;
  }

  @override
  String? get token => _authBloc?.token;
}
