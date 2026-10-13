import 'package:booking_app/features/booking/data/datasources/booking_local_datasource.dart';
import 'package:booking_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:booking_app/features/booking/data/models/create_booking_request.dart';
import 'package:booking_app/features/booking/data/models/get_booked_slots_request.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._remote, this._local);

  final BookingRemoteDataSource _remote;
  final BookingLocalDataSource _local;

  @override
  Future<Set<TimeSlot>> getBookedSlots(String providerId, DateTime date) async {
    final (remote, local) = await (
      _remote.getBookings(
        GetBookedSlotsRequest(providerId: providerId, date: date),
      ),
      _local.getActiveSlots(providerId, date),
    ).wait;
    return {...remote.map((b) => b.timeSlot), ...local};
  }

  @override
  Future<BookingEntity> createBooking(CreateBookingParams params) async {
    if (await _local.isSlotTaken(
      params.providerId,
      params.date,
      params.timeSlot,
    )) {
      throw const BookingException(
        'Sorry, this slot was just booked. Please pick another one.',
      );
    }

    final booking = await _remote.createBooking(
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
    await _local.saveBooking(booking);
    return booking;
  }

  @override
  Future<List<BookingEntity>> getMyBookings() async {
    final bookings = await _local.getBookings();
    return bookings..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0
          ? byDate
          : a.timeSlot.startHour.compareTo(b.timeSlot.startHour);
    });
  }

  @override
  Future<BookingEntity> cancelBooking(String bookingId) async {
    final booking = await _local.getBooking(bookingId);
    if (booking == null) {
      throw const BookingException('Booking not found.');
    }
    if (!booking.canCancel(DateTime.now())) {
      throw const BookingException('This booking can no longer be cancelled.');
    }

    final cancelled = BookingModel.fromJson({
      ...booking.toJson(),
      'status': BookingStatus.cancelled.name,
    });
    await _local.updateBooking(cancelled);
    return cancelled;
  }
}
