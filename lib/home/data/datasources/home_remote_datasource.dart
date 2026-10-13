import 'package:booking_app/home/data/models/categories_response.dart';
import 'package:booking_app/home/data/models/get_categories_request.dart';
import 'package:booking_app/home/data/models/get_providers_request.dart';
import 'package:booking_app/home/data/models/providers_response.dart';

abstract class HomeRemoteDataSource {
  Future<CategoriesResponse> getCategories(GetCategoriesRequest request);
  Future<ProvidersResponse> getProviders(GetProvidersRequest request);
}
