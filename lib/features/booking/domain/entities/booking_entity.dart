import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.providerId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.estimatedHours,
    required this.description,
    required this.status,
  });

  final String id;
  final String providerId;
  final String customerName;
  final String phone;
  final String address;
  final DateTime date;
  final TimeSlot timeSlot;
  final int estimatedHours;
  final String description;
  final BookingStatus status;

  static const cancellationNotice = Duration(hours: 24);

  DateTime get startsAt =>
      DateTime(date.year, date.month, date.day, timeSlot.startHour);

  bool canCancel(DateTime now) =>
      (status == BookingStatus.pending || status == BookingStatus.confirmed) &&
      startsAt.difference(now) > cancellationNotice;
}
