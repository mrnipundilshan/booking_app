import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class GetMyBookingsUseCase {
  const GetMyBookingsUseCase(this._repository);

  final BookingRepository _repository;

  Future<List<BookingEntity>> call() => _repository.getMyBookings();
}
