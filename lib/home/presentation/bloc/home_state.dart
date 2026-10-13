part of 'home_bloc.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.categories);

  final List<CategoryEntity> categories;
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}
