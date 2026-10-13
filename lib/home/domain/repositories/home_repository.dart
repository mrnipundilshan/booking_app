import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/core/common/entities/provider_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<ProviderEntity>> getProviders(String categoryId);
  Future<List<ProviderEntity>> searchProviders(String query);
}
