import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

abstract class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();
  Future<void> saveBooking(BookingModel booking);
  Future<BookingModel?> getBooking(String bookingId);
  Future<void> updateBooking(BookingModel booking);
  Future<bool> isSlotTaken(String providerId, DateTime date, TimeSlot slot);
  Future<Set<TimeSlot>> getActiveSlots(String providerId, DateTime date);
}
