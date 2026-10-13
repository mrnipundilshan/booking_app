import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

class CreateBookingRequest {
  const CreateBookingRequest({
    required this.providerId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.estimatedHours,
    required this.description,
  });

  final String providerId;
  final String customerName;
  final String phone;
  final String address;
  final DateTime date;
  final TimeSlot timeSlot;
  final int estimatedHours;
  final String description;

  Map<String, dynamic> toJson() => {
    'providerId': providerId,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'date': date.toIso8601String(),
    'timeSlot': timeSlot.name,
    'estimatedHours': estimatedHours,
    'description': description,
  };
}
