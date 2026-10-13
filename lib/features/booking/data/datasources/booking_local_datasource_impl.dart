import 'package:booking_app/features/booking/data/datasources/booking_local_datasource.dart';
import 'package:booking_app/features/booking/data/models/booking_model.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:sqflite/sqflite.dart';

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  const BookingLocalDataSourceImpl(this._db);

  final Database _db;

  static const _table = 'bookings';
  static final _inactive = [
    BookingStatus.cancelled,
    BookingStatus.rejected,
  ].map((s) => s.name).toList();

  @override
  Future<List<BookingModel>> getBookings() async {
    final rows = await _db.query(_table);
    return rows.map(BookingModel.fromJson).toList();
  }

  @override
  Future<List<BookingModel>> getBookingsForProvider(String providerId) async {
    final rows = await _db.query(
      _table,
      where: 'providerId = ?',
      whereArgs: [providerId],
    );
    return rows.map(BookingModel.fromJson).toList();
  }

  @override
  Future<void> saveBooking(BookingModel booking) async {
    await _db.insert(_table, booking.toJson());
  }

  @override
  Future<BookingModel?> getBooking(String bookingId) async {
    final rows = await _db.query(
      _table,
      where: 'id = ?',
      whereArgs: [bookingId],
      limit: 1,
    );
    return rows.isEmpty ? null : BookingModel.fromJson(rows.first);
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    await _db.update(
      _table,
      booking.toJson(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  @override
  Future<bool> isSlotTaken(
    String providerId,
    DateTime date,
    TimeSlot slot,
  ) async {
    return (await getActiveSlots(providerId, date)).contains(slot);
  }

  @override
  Future<Set<TimeSlot>> getActiveSlots(String providerId, DateTime date) async {
    final rows = await _db.query(
      _table,
      columns: ['timeSlot'],
      where:
          'providerId = ? AND substr(date, 1, 10) = ? AND status NOT IN (${List.filled(_inactive.length, '?').join(', ')})',
      whereArgs: [providerId, _dayKey(date), ..._inactive],
    );
    return rows
        .map((r) => TimeSlot.values.byName(r['timeSlot'] as String))
        .toSet();
  }

  static String _dayKey(DateTime date) => DateTime(
    date.year,
    date.month,
    date.day,
  ).toIso8601String().substring(0, 10);
}
