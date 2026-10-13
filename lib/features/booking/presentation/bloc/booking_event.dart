part of 'booking_bloc.dart';

sealed class BookingEvent {
  const BookingEvent();
}

final class BookedSlotsRequested extends BookingEvent {
  const BookedSlotsRequested(this.providerId, this.date);

  final String providerId;
  final DateTime date;
}

final class BookingSubmitted extends BookingEvent {
  const BookingSubmitted(this.params);

  final CreateBookingParams params;
}
