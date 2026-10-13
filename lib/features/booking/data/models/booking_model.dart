import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.providerId,
    required super.customerName,
    required super.phone,
    required super.address,
    required super.date,
    required super.timeSlot,
    required super.estimatedHours,
    required super.description,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      customerName: json['customerName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: TimeSlot.values.byName(json['timeSlot'] as String),
      estimatedHours: (json['estimatedHours'] as num).toInt(),
      description: json['description'] as String,
      status: json['status'] == null
          ? BookingStatus.pending
          : BookingStatus.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'providerId': providerId,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'date': date.toIso8601String(),
    'timeSlot': timeSlot.name,
    'estimatedHours': estimatedHours,
    'description': description,
    'status': status.name,
  };
}
