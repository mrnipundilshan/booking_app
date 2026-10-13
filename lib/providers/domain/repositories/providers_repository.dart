import 'package:booking_app/core/common/entities/provider_entity.dart';

abstract class ProvidersRepository {
  Future<List<ProviderEntity>> getAllProviders();
}
