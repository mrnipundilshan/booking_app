import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/home/domain/repositories/home_repository.dart';

class SearchProvidersUseCase {
  const SearchProvidersUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<ProviderEntity>> call(String query) =>
      _repository.searchProviders(query);
}
