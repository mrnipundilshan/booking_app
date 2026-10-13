import 'dart:convert';

import 'package:booking_app/home/data/datasources/home_remote_datasource.dart';
import 'package:booking_app/home/data/models/categories_response.dart';
import 'package:booking_app/home/data/models/get_categories_request.dart';
import 'package:booking_app/home/data/models/get_providers_request.dart';
import 'package:booking_app/home/data/models/providers_response.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<CategoriesResponse> getCategories(GetCategoriesRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    final raw = await rootBundle.loadString('assets/data/categories.json');
    return CategoriesResponse.fromJson(jsonDecode(raw));
  }

  @override
  Future<ProvidersResponse> getProviders(GetProvidersRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    final raw = await rootBundle.loadString('assets/data/providers.json');
    final all = ProvidersResponse.fromJson(jsonDecode(raw));
    return ProvidersResponse(
      providers: all.providers
          .where((p) => p.categoryId == request.categoryId)
          .toList(),
    );
  }
}
