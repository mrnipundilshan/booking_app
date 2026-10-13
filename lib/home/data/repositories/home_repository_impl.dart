import 'package:booking_app/home/data/datasources/home_remote_datasource.dart';
import 'package:booking_app/home/data/models/get_categories_request.dart';
import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remote);

  final HomeRemoteDataSource _remote;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await _remote.getCategories(const GetCategoriesRequest());
    return response.categories;
  }
}
