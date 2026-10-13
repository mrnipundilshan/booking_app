import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:booking_app/features/booking/data/models/create_booking_request.dart';
import 'package:booking_app/features/booking/data/models/get_booked_slots_request.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings(GetBookedSlotsRequest request);
  Future<BookingModel> createBooking(CreateBookingRequest request);
  Future<List<BookingModel>> getMyBookings();
}

class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}
