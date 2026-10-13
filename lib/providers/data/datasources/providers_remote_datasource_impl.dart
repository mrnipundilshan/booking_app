import 'dart:convert';

import 'package:booking_app/core/common/models/providers_response.dart';
import 'package:booking_app/providers/data/datasources/providers_remote_datasource.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProvidersRemoteDataSourceImpl implements ProvidersRemoteDataSource {
  const ProvidersRemoteDataSourceImpl();

  @override
  Future<ProvidersResponse> getAllProviders() async {
    await Future.delayed(const Duration(seconds: 1));
    final raw = await rootBundle.loadString('assets/data/data.json');
    return ProvidersResponse.fromJson(jsonDecode(raw));
  }
}
