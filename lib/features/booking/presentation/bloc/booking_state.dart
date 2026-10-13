part of 'booking_bloc.dart';

enum BookingStatus { idle, submitting, success, failure }

final class BookingState {
  const BookingState({
    this.date,
    this.bookedSlots = const {},
    this.loadingSlots = false,
    this.status = BookingStatus.idle,
    this.booking,
    this.errorMessage,
  });

  final DateTime? date;
  final Set<TimeSlot> bookedSlots;
  final bool loadingSlots;
  final BookingStatus status;
  final BookingEntity? booking;

  final String? errorMessage;

  BookingState copyWith({
    DateTime? date,
    Set<TimeSlot>? bookedSlots,
    bool? loadingSlots,
    BookingStatus? status,
    BookingEntity? booking,
    String? errorMessage,
  }) {
    return BookingState(
      date: date ?? this.date,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      loadingSlots: loadingSlots ?? this.loadingSlots,
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage,
    );
  }
}
