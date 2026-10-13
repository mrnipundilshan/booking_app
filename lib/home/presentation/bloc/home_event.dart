part of 'home_bloc.dart';

class HomeEvent {
  const HomeEvent();
}

final class SearchProviders extends HomeEvent {
  const SearchProviders(this.query);

  final String query;
}

final class LoadCategories extends HomeEvent {
  const LoadCategories();
}
