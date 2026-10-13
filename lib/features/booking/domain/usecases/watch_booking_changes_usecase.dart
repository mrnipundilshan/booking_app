import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class WatchBookingChangesUseCase {
  const WatchBookingChangesUseCase(this._repository);

  final BookingRepository _repository;

  Stream<void> call() => _repository.changes;
}
