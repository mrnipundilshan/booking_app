import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class CancelBookingUseCase {
  const CancelBookingUseCase(this._repository);

  final BookingRepository _repository;

  Future<BookingEntity> call(String bookingId) =>
      _repository.cancelBooking(bookingId);
}
