import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/get_my_bookings_usecase.dart';
import 'package:booking_app/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/features/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_bookings_event.dart';
part 'my_bookings_state.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  final GetMyBookingsUseCase _getMyBookings;

  final GetAllProvidersUseCase _getAllProviders;

  final GetCategoriesUseCase _getCategories;

  final CancelBookingUseCase _cancelBooking;

  MyBookingsBloc(
    this._getMyBookings,
    this._getAllProviders,
    this._getCategories,
    this._cancelBooking,
  ) : super(const MyBookingsLoading()) {
    on<LoadMyBookings>(_onLoad);
    on<CancelBooking>(_onCancel);
  }

  Future<void> _onLoad(
    LoadMyBookings event,
    Emitter<MyBookingsState> emit,
  ) async {
    emit(const MyBookingsLoading());
    try {
      final (bookings, providers, categories) = await (
        _getMyBookings(),
        _getAllProviders(),
        _getCategories(),
      ).wait;
      emit(
        _loaded(
          bookings,
          providers: {for (final p in providers) p.id: p},
          categoryNames: {for (final c in categories) c.id: c.name},
        ),
      );
    } catch (e) {
      emit(MyBookingsError(e.toString()));
    }
  }

  Future<void> _onCancel(
    CancelBooking event,
    Emitter<MyBookingsState> emit,
  ) async {
    final current = state;
    if (current is! MyBookingsLoaded || current.cancellingId != null) return;

    emit(current.copyWith(cancellingId: event.bookingId));
    try {
      final cancelled = await _cancelBooking(event.bookingId);
      emit(
        _loaded(
          [
            for (final b in [...current.upcoming, ...current.history])
              b.id == cancelled.id ? cancelled : b,
          ],
          providers: current.providers,
          categoryNames: current.categoryNames,
          message: 'Booking ${cancelled.id} cancelled',
        ),
      );
    } catch (e) {
      emit(current.copyWith(message: e.toString()));
    }
  }

  MyBookingsLoaded _loaded(
    List<BookingEntity> bookings, {
    required Map<String, ProviderEntity> providers,
    required Map<String, String> categoryNames,
    String? message,
  }) {
    int byStart(BookingEntity a, BookingEntity b) =>
        a.startsAt.compareTo(b.startsAt);

    return MyBookingsLoaded(
      upcoming: bookings.where((b) => b.status.isUpcoming).toList()
        ..sort(byStart),
      history: bookings.where((b) => !b.status.isUpcoming).toList()
        ..sort((a, b) => byStart(b, a)),
      providers: providers,
      categoryNames: categoryNames,
      message: message,
    );
  }
}
