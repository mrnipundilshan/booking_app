import 'package:booking_app/features/booking/domain/entities/time_slot.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class GetBookedSlotsUseCase {
  const GetBookedSlotsUseCase(this._repository);

  final BookingRepository _repository;

  Future<Set<TimeSlot>> call(String providerId, DateTime date) =>
      _repository.getBookedSlots(providerId, date);
}
