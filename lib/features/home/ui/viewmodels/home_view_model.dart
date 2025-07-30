import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_flutter/features/home/data/models/state_model.dart';
import 'package:prueba_flutter/features/home/data/repositories/home_repository_impl.dart';
import 'package:prueba_flutter/features/home/domain/repositories/home_repository.dart';

final stateSelectedProvider = StateProvider<StateModel?>((ref) => null);

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  final repo = ref.watch(homeRepositoryProvider);
  return HomeViewModel(repo);
});

class HomeState {
  final bool isLoading;
  final List<StateModel> stateList;
  final String? error;

  HomeState({this.isLoading = false, this.stateList = const [], this.error});

  HomeState copyWith({
    bool? isLoading,
    List<StateModel>? stateList,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      stateList: stateList ?? this.stateList,
      error: error,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeRepository repository;

  HomeViewModel(this.repository) : super(HomeState()) {
    getStates();
  }

  Future<void> getStates() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stateList = await repository.getStates();

      state = state.copyWith(stateList: stateList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
