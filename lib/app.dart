import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/pages/product_list_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()),
      ],
      child: MaterialApp(
        title: 'Clean Architecture Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const _AppGate(),
      ),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        final productBloc = context.read<ProductBloc>();
        if (state is AuthAuthenticated) {
          productBloc.add(const ProductStarted());
          return;
        }
        if (state is AuthUnauthenticated) {
          productBloc.add(const ProductResetRequested());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
        builder: (context, state) {
          return switch (state) {
            AuthInitial() || AuthLoading() => const SplashPage(),
            AuthAuthenticated() => const ProductListPage(),
            _ => const LoginPage(),
          };
        },
      ),
    );
  }
}
