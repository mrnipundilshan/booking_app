import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/home/domain/usecases/get_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'providers_event.dart';
part 'providers_state.dart';

class ProvidersBloc extends Bloc<ProvidersEvent, ProvidersState> {
  final GetProvidersUseCase _getProviders;

  ProvidersBloc(this._getProviders) : super(const ProvidersLoading()) {
    on<LoadProviders>(_onLoadProviders);
  }

  Future<void> _onLoadProviders(
    LoadProviders event,
    Emitter<ProvidersState> emit,
  ) async {
    emit(const ProvidersLoading());
    try {
      emit(ProvidersLoaded(await _getProviders(event.categoryId)));
    } catch (e) {
      emit(ProvidersError(e.toString()));
    }
  }
}
