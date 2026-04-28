import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:bloc_state_management/features/auth/domain/model/user_model.dart';
import 'package:bloc_state_management/features/auth/domain/usecases/login_usecase.dart';
import 'package:bloc_state_management/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bloc_state_management/core/error/failure.dart';
import 'package:bloc_state_management/core/usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLoginSubmitted, transformer: sequential());
    on<AuthLogoutRequested>(_onLogoutRequested, transformer: sequential());
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

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
    final result = await _loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );
    result.fold((failure) {
      emit(AuthFailureState(failure));
      emit(const AuthUnauthenticated());
    }, (user) => emit(AuthAuthenticated(user)));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthFailureState(failure)),
      (_) => emit(const AuthUnauthenticated()),
    );
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
