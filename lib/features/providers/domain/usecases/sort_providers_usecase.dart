import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/providers/domain/repositories/providers_repository.dart';

class SortProvidersUseCase {
  const SortProvidersUseCase(this._repository);

  final ProvidersRepository _repository;

  Future<List<ProviderEntity>> call(
    String sortBy, {
    String? categoryId,
    double? minRating,
    int? minRate,
    int? maxRate,
    bool availableOnly = false,
  }) => _repository.sortProviders(
    sortBy,
    categoryId: categoryId,
    minRating: minRating,
    minRate: minRate,
    maxRate: maxRate,
    availableOnly: availableOnly,
  );
}
