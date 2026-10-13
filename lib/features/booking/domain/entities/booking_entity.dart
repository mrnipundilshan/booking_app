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
}
