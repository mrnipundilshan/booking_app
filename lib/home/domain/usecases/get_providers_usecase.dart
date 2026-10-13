import 'package:booking_app/home/domain/entities/provider_entity.dart';
import 'package:booking_app/home/domain/repositories/home_repository.dart';

class GetProvidersUseCase {
  const GetProvidersUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<ProviderEntity>> call(String categoryId) =>
      _repository.getProviders(categoryId);
}
