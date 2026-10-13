import 'package:booking_app/core/common/models/providers_response.dart';
import 'package:booking_app/providers/data/models/filter_providers_request.dart';

abstract class ProvidersRemoteDataSource {
  Future<ProvidersResponse> getAllProviders();
  Future<ProvidersResponse> filterProviders(FilterProvidersRequest request);
}
