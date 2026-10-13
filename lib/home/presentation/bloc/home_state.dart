part of 'home_bloc.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.categories, {this.query = '', this.results = const []});

  final List<CategoryEntity> categories;

  final String query;

  final List<ProviderEntity> results;

  bool get isSearching => query.isNotEmpty;
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}
