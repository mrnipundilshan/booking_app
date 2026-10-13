import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/providers/domain/repositories/providers_repository.dart';

class GetAllProvidersUseCase {
  const GetAllProvidersUseCase(this._repository);

  final ProvidersRepository _repository;

  Future<List<ProviderEntity>> call() => _repository.getAllProviders();
}
