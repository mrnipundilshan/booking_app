part of 'my_bookings_bloc.dart';

sealed class MyBookingsState {
  const MyBookingsState();
}

final class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

final class MyBookingsLoaded extends MyBookingsState {
  const MyBookingsLoaded({
    required this.upcoming,
    required this.history,
    required this.providers,
    required this.categoryNames,
    this.cancellingId,
    this.message,
  });

  final List<BookingEntity> upcoming;

  final List<BookingEntity> history;

  final Map<String, ProviderEntity> providers;

  final Map<String, String> categoryNames;

  final String? cancellingId;

  final String? message;

  MyBookingsLoaded copyWith({String? cancellingId, String? message}) =>
      MyBookingsLoaded(
        upcoming: upcoming,
        history: history,
        providers: providers,
        categoryNames: categoryNames,
        cancellingId: cancellingId,
        message: message,
      );
}

final class MyBookingsError extends MyBookingsState {
  const MyBookingsError(this.message);

  final String message;
}
