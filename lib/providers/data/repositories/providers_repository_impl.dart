import 'package:booking_app/providers/data/datasources/providers_remote_datasource.dart';
import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/providers/domain/repositories/providers_repository.dart';

class ProvidersRepositoryImpl implements ProvidersRepository {
  const ProvidersRepositoryImpl(this._remote);

  final ProvidersRemoteDataSource _remote;

  @override
  Future<List<ProviderEntity>> getAllProviders() async {
    final response = await _remote.getAllProviders();
    return response.providers;
  }
}
