import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_flutter/features/login/data/repositories/login_repository_impl.dart';
import 'package:prueba_flutter/features/login/domain/repositories/login_repository.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl();
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final repo = ref.watch(loginRepositoryProvider);
      return LoginViewModel(repo);
    });

class LoginState {
  final bool isLoading;
  final bool isLogin;
  final String? error;

  LoginState({this.isLoading = false, this.isLogin = false, this.error});

  LoginState copyWith({bool? isLoading, bool? isLogin, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isLogin: isLogin ?? this.isLogin,
      error: error,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginRepository repository;

  LoginViewModel(this.repository) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final login = await repository.login(email: email, password: password);

      state = state.copyWith(isLogin: login.isNotEmpty, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
