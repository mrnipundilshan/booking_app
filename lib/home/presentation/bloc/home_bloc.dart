import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeLoading()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      final raw = await rootBundle.loadString('assets/data/categories.json');
      final list = (jsonDecode(raw)['categories'] as List)
          .cast<Map<String, dynamic>>();
      emit(HomeLoaded(list));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
