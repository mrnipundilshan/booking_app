part of 'my_bookings_bloc.dart';

sealed class MyBookingsState {
  const MyBookingsState();
}

final class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

final class MyBookingsLoaded extends MyBookingsState {
  const MyBookingsLoaded({required this.bookings, required this.providers});

  final List<BookingEntity> bookings;

  final Map<String, ProviderEntity> providers;
}

final class MyBookingsError extends MyBookingsState {
  const MyBookingsError(this.message);

  final String message;
}
