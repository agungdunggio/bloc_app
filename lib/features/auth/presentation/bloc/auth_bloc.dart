import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../domain/model/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository authRepository,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _authRepository = authRepository,
       super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLoginSubmitted, transformer: sequential());
    on<AuthLogoutRequested>(_onLogoutRequested, transformer: sequential());
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  String? get token => switch (state) {
    AuthAuthenticated(:final user) => user.token,
    _ => null,
  };

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticated) return;
    emit(const AuthUnauthenticated());
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(
        LoginParams(username: event.username, password: event.password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailureState(_authRepository.mapExceptionToFailure(e)));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    if (token == null || token.isEmpty) return const AuthUnauthenticated();

    return AuthAuthenticated(
      UserModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        username: json['username'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        token: token,
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state case AuthAuthenticated(:final user)) {
      return jsonDecode(
            jsonEncode({
              'id': user.id,
              'username': user.username,
              'firstName': user.firstName,
              'lastName': user.lastName,
              'token': user.token,
            }),
          )
          as Map<String, dynamic>;
    }
    return {'token': ''};
  }
}
