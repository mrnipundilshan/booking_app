import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<CategoryEntity>> call() => _repository.getCategories();
}
