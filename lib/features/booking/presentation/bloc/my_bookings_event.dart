part of 'my_bookings_bloc.dart';

class MyBookingsEvent {
  const MyBookingsEvent();
}

final class LoadMyBookings extends MyBookingsEvent {
  const LoadMyBookings();
}

final class CancelBooking extends MyBookingsEvent {
  const CancelBooking(this.bookingId);

  final String bookingId;
}

final class MyBookingsChanged extends MyBookingsEvent {
  const MyBookingsChanged();
}
