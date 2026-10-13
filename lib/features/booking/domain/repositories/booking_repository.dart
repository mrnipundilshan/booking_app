import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/provider_action.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';

abstract class BookingRepository {
  Stream<void> get changes;

  Future<Set<TimeSlot>> getBookedSlots(String providerId, DateTime date);

  Future<BookingEntity> createBooking(CreateBookingParams params);

  Future<List<BookingEntity>> getMyBookings();

  Future<BookingEntity> cancelBooking(String bookingId);

  Future<List<BookingEntity>> getProviderJobs(String providerId);

  Future<BookingEntity> applyProviderAction({
    required String providerId,
    required String bookingId,
    required ProviderAction action,
  });
}
