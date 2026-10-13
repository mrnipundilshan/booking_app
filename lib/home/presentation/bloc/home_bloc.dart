import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/domain/entities/provider_entity.dart';
import 'package:booking_app/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/home/domain/usecases/search_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategories;

  final SearchProvidersUseCase _searchProviders;

  HomeBloc(this._getCategories, this._searchProviders)
    : super(const HomeLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<SearchProviders>(_onSearchProviders);
  }

  Future<void> _onSearchProviders(
    SearchProviders event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;
    if (current is! HomeLoaded) return;
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(HomeLoaded(current.categories));
      return;
    }
    try {
      final results = await _searchProviders(query);
      emit(HomeLoaded(current.categories, query: query, results: results));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      emit(HomeLoaded(await _getCategories()));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
