import 'package:booking_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:booking_app/features/booking/data/models/create_booking_request.dart';
import 'package:booking_app/features/booking/data/models/get_booked_slots_request.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._remote);

  final BookingRemoteDataSource _remote;

  @override
  Future<Set<TimeSlot>> getBookedSlots(String providerId, DateTime date) async {
    final bookings = await _remote.getBookings(
      GetBookedSlotsRequest(providerId: providerId, date: date),
    );
    return bookings.map((b) => b.timeSlot).toSet();
  }

  @override
  Future<BookingEntity> createBooking(CreateBookingParams params) {
    return _remote.createBooking(
      CreateBookingRequest(
        providerId: params.providerId,
        customerName: params.customerName,
        phone: params.phone,
        address: params.address,
        date: params.date,
        timeSlot: params.timeSlot,
        estimatedHours: params.estimatedHours,
        description: params.description,
      ),
    );
  }

  @override
  Future<List<BookingEntity>> getMyBookings() async {
    final bookings = await _remote.getMyBookings();
    return bookings..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0
          ? byDate
          : a.timeSlot.startHour.compareTo(b.timeSlot.startHour);
    });
  }
}
