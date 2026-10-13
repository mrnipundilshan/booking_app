import 'dart:convert';

import 'package:booking_app/home/data/datasources/home_remote_datasource.dart';
import 'package:booking_app/home/data/models/categories_response.dart';
import 'package:booking_app/home/data/models/get_categories_request.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<CategoriesResponse> getCategories(GetCategoriesRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    final raw = await rootBundle.loadString('assets/data/categories.json');
    return CategoriesResponse.fromJson(jsonDecode(raw));
  }
}
