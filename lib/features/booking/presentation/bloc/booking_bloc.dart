import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/get_booked_slots_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookedSlotsUseCase _getBookedSlots;

  final CreateBookingUseCase _createBooking;

  BookingBloc(this._getBookedSlots, this._createBooking)
    : super(const BookingState()) {
    on<BookedSlotsRequested>(_onBookedSlotsRequested);
    on<BookingSubmitted>(_onSubmitted);
  }

  Future<void> _onBookedSlotsRequested(
    BookedSlotsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(
      state.copyWith(
        date: event.date,
        bookedSlots: const {},
        loadingSlots: true,
      ),
    );
    try {
      final booked = await _getBookedSlots(event.providerId, event.date);
      if (state.date != event.date) return;
      emit(state.copyWith(bookedSlots: booked, loadingSlots: false));
    } catch (e) {
      if (state.date != event.date) return;
      emit(state.copyWith(loadingSlots: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSubmitted(
    BookingSubmitted event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.submitting));
    try {
      final booking = await _createBooking(event.params);
      emit(
        state.copyWith(
          status: BookingStatus.success,
          booking: booking,
          bookedSlots: {...state.bookedSlots, booking.timeSlot},
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      add(BookedSlotsRequested(event.params.providerId, event.params.date));
    }
  }
}
