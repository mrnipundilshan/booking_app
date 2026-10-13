import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/providers/domain/usecases/filter_providers_usecase.dart';
import 'package:booking_app/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'providers_event.dart';
part 'providers_state.dart';

class AllProvidersBloc extends Bloc<AllProvidersEvent, AllProvidersState> {
  final GetAllProvidersUseCase _getAllProviders;

  final FilterProvidersUseCase _filterProviders;

  AllProvidersBloc(this._getAllProviders, this._filterProviders)
    : super(const AllProvidersLoading()) {
    on<LoadAllProviders>(_onLoad);
    on<FilterProviders>(_onFilter);
  }

  Future<void> _onLoad(
    LoadAllProviders event,
    Emitter<AllProvidersState> emit,
  ) async {
    emit(const AllProvidersLoading());
    try {
      emit(AllProvidersLoaded(await _getAllProviders()));
    } catch (e) {
      emit(AllProvidersError(e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterProviders event,
    Emitter<AllProvidersState> emit,
  ) async {
    emit(const AllProvidersLoading());
    try {
      final providers = await _filterProviders(
        categoryId: event.categoryId,
        minRating: event.minRating,
        minRate: event.minRate,
        maxRate: event.maxRate,
        availableOnly: event.availableOnly,
      );
      emit(AllProvidersLoaded(providers));
    } catch (e) {
      emit(AllProvidersError(e.toString()));
    }
  }
}
