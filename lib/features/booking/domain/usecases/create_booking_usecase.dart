import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class CreateBookingUseCase {
  const CreateBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<BookingEntity> call(CreateBookingParams params) =>
      _repository.createBooking(params);
}

class CreateBookingParams {
  const CreateBookingParams({
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
}
