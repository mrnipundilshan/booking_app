import 'package:booking_app/features/home/data/models/categories_response.dart';
import 'package:booking_app/features/home/data/models/get_categories_request.dart';
import 'package:booking_app/features/home/data/models/get_providers_request.dart';
import 'package:booking_app/core/common/models/providers_response.dart';

abstract class HomeRemoteDataSource {
  Future<CategoriesResponse> getCategories(GetCategoriesRequest request);
  Future<ProvidersResponse> getProviders(GetProvidersRequest request);
  Future<ProvidersResponse> searchProviders(String query);
}
