import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';

class GetProviderJobsUseCase {
  const GetProviderJobsUseCase(this._repository);

  final BookingRepository _repository;

  Future<List<BookingEntity>> call(String providerId) =>
      _repository.getProviderJobs(providerId);
}
