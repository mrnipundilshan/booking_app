import 'package:booking_app/core/common/entities/provider_entity.dart';

abstract class ProvidersRepository {
  Future<List<ProviderEntity>> getAllProviders();

  Future<List<ProviderEntity>> filterProviders({
    String? categoryId,
    double? minRating,
    int? minRate,
    int? maxRate,
    bool availableOnly = false,
  });
}
