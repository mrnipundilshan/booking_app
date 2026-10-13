import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/provider_action.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class ApplyProviderActionUseCase {
  const ApplyProviderActionUseCase(this._repository);

  final BookingRepository _repository;

  Future<BookingEntity> call({
    required String providerId,
    required String bookingId,
    required ProviderAction action,
  }) => _repository.applyProviderAction(
    providerId: providerId,
    bookingId: bookingId,
    action: action,
  );
}
