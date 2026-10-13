import 'package:booking_app/providers/data/datasources/providers_remote_datasource.dart';
import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/providers/data/models/filter_providers_request.dart';
import 'package:booking_app/providers/data/models/sort_providers_request.dart';
import 'package:booking_app/providers/domain/repositories/providers_repository.dart';

class ProvidersRepositoryImpl implements ProvidersRepository {
  const ProvidersRepositoryImpl(this._remote);

  final ProvidersRemoteDataSource _remote;

  @override
  Future<List<ProviderEntity>> getAllProviders() async {
    final response = await _remote.getAllProviders();
    return response.providers;
  }

  @override
  Future<List<ProviderEntity>> filterProviders({
    String? categoryId,
    double? minRating,
    int? minRate,
    int? maxRate,
    bool availableOnly = false,
  }) async {
    final response = await _remote.filterProviders(
      FilterProvidersRequest(
        categoryId: categoryId,
        minRating: minRating,
        minRate: minRate,
        maxRate: maxRate,
        availableOnly: availableOnly,
      ),
    );
    return response.providers;
  }

  @override
  Future<List<ProviderEntity>> sortProviders(
    String sortBy, {
    String? categoryId,
    double? minRating,
    int? minRate,
    int? maxRate,
    bool availableOnly = false,
  }) async {
    final response = await _remote.sortProviders(
      SortProvidersRequest(
        sortBy: sortBy,
        filter: FilterProvidersRequest(
          categoryId: categoryId,
          minRating: minRating,
          minRate: minRate,
          maxRate: maxRate,
          availableOnly: availableOnly,
        ),
      ),
    );
    return response.providers;
  }
}
