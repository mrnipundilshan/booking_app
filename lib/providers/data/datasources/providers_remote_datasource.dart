import 'package:booking_app/core/common/models/providers_response.dart';

abstract class ProvidersRemoteDataSource {
  Future<ProvidersResponse> getAllProviders();
}
