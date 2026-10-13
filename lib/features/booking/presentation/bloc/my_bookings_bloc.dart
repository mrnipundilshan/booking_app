import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/usecases/get_my_bookings_usecase.dart';
import 'package:booking_app/features/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_bookings_event.dart';
part 'my_bookings_state.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  final GetMyBookingsUseCase _getMyBookings;

  final GetAllProvidersUseCase _getAllProviders;

  MyBookingsBloc(this._getMyBookings, this._getAllProviders)
    : super(const MyBookingsLoading()) {
    on<LoadMyBookings>(_onLoad);
  }

  Future<void> _onLoad(
    LoadMyBookings event,
    Emitter<MyBookingsState> emit,
  ) async {
    emit(const MyBookingsLoading());
    try {
      final (bookings, providers) = await (
        _getMyBookings(),
        _getAllProviders(),
      ).wait;
      emit(
        MyBookingsLoaded(
          bookings: bookings,
          providers: {for (final p in providers) p.id: p},
        ),
      );
    } catch (e) {
      emit(MyBookingsError(e.toString()));
    }
  }
}
