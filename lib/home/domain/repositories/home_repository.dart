import 'package:booking_app/home/domain/entities/category_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();
}
