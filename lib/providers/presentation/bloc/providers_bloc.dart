import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'providers_event.dart';
part 'providers_state.dart';

class AllProvidersBloc extends Bloc<AllProvidersEvent, AllProvidersState> {
  final GetAllProvidersUseCase _getAllProviders;

  AllProvidersBloc(this._getAllProviders) : super(const AllProvidersLoading()) {
    on<LoadAllProviders>(_onLoad);
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
}
