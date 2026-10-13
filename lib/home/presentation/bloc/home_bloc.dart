import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase _getCategories;

  HomeBloc(this._getCategories) : super(const HomeLoading()) {
    on<LoadCategories>(_onLoadCategories);
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
