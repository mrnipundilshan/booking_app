import 'package:booking_app/home/data/models/categories_response.dart';
import 'package:booking_app/home/data/models/get_categories_request.dart';

abstract class HomeRemoteDataSource {
  Future<CategoriesResponse> getCategories(GetCategoriesRequest request);
}
