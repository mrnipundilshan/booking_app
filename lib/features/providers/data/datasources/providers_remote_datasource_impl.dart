import 'dart:convert';

import 'package:booking_app/core/common/models/providers_response.dart';
import 'package:booking_app/features/providers/data/datasources/providers_remote_datasource.dart';
import 'package:booking_app/features/providers/data/models/filter_providers_request.dart';
import 'package:booking_app/features/providers/data/models/sort_providers_request.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProvidersRemoteDataSourceImpl implements ProvidersRemoteDataSource {
  const ProvidersRemoteDataSourceImpl();

  @override
  Future<ProvidersResponse> getAllProviders() async {
    await Future.delayed(const Duration(seconds: 1));
    final raw = await rootBundle.loadString('assets/data/data.json');
    return ProvidersResponse.fromJson(jsonDecode(raw));
  }

  @override
  Future<ProvidersResponse> filterProviders(
    FilterProvidersRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return ProvidersResponse(providers: await _filtered(request));
  }

  @override
  Future<ProvidersResponse> sortProviders(SortProvidersRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    final providers = await _filtered(request.filter);

    switch (request.sortBy) {
      case 'rating':
        providers.sort((a, b) => b.rating.compareTo(a.rating));
      case 'hourlyRate':
        providers.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
      case 'experience':
        providers.sort(
          (a, b) => b.experienceYears.compareTo(a.experienceYears),
        );
    }

    return ProvidersResponse(providers: providers);
  }

  Future<List<ProviderModel>> _filtered(FilterProvidersRequest request) async {
    final raw = await rootBundle.loadString('assets/data/data.json');
    final all = ProvidersResponse.fromJson(jsonDecode(raw));
    return all.providers.where((p) {
      if (request.categoryId != null && p.categoryId != request.categoryId) {
        return false;
      }
      if (request.minRating != null && p.rating < request.minRating!) {
        return false;
      }
      if (request.minRate != null && p.hourlyRate < request.minRate!) {
        return false;
      }
      if (request.maxRate != null && p.hourlyRate > request.maxRate!) {
        return false;
      }
      if (request.availableOnly && !p.isAvailable) return false;
      return true;
    }).toList();
  }
}
