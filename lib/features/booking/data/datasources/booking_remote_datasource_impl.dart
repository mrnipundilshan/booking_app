import 'package:booking_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:booking_app/features/booking/data/models/create_booking_request.dart';
import 'package:booking_app/features/booking/data/models/get_booked_slots_request.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl() : _bookings = _seed(DateTime.now());

  final List<BookingModel> _bookings;

  @override
  Future<List<BookingModel>> getBookings(GetBookedSlotsRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings
        .where(
          (b) =>
              b.providerId == request.providerId &&
              _isSameDay(b.date, request.date),
        )
        .toList();
  }

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    final taken = _bookings.any(
      (b) =>
          b.providerId == request.providerId &&
          _isSameDay(b.date, request.date) &&
          b.timeSlot == request.timeSlot,
    );
    if (taken) {
      throw const BookingException(
        'Sorry, this slot was just booked. Please pick another one.',
      );
    }

    final booking = BookingModel.fromJson({
      ...request.toJson(),
      'id': 'b${DateTime.now().microsecondsSinceEpoch}',
    });
    _bookings.add(booking);
    return booking;
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static List<BookingModel> _seed(DateTime now) {
    // Next two bookable (non-Sunday) days from tomorrow.
    final days = <DateTime>[];
    for (var i = 1; days.length < 2; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      if (day.weekday != DateTime.sunday) days.add(day);
    }

    BookingModel booking(
      String id,
      String providerId,
      DateTime date,
      TimeSlot slot,
    ) {
      return BookingModel(
        id: id,
        providerId: providerId,
        customerName: 'Existing Customer',
        phone: '0771234567',
        address: 'No. 1, Main Street, Colombo',
        date: date,
        timeSlot: slot,
        estimatedHours: 2,
        description: 'Existing booking',
      );
    }

    return [
      booking('seed1', 'p001', days[0], TimeSlot.slot8to10),
      booking('seed2', 'p001', days[0], TimeSlot.slot1to3),
      booking('seed3', 'p001', days[1], TimeSlot.slot10to12),
      booking('seed4', 'p003', days[0], TimeSlot.slot10to12),
      booking('seed5', 'p003', days[0], TimeSlot.slot3to5),
    ];
  }
}
