import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';

abstract class BookingRepository {
  Future<Set<TimeSlot>> getBookedSlots(String providerId, DateTime date);

  Future<BookingEntity> createBooking(CreateBookingParams params);

  Future<List<BookingEntity>> getMyBookings();
}
