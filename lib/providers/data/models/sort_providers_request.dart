import 'package:booking_app/providers/data/models/filter_providers_request.dart';

class SortProvidersRequest {
  const SortProvidersRequest({required this.sortBy, required this.filter});

  final String sortBy;

  final FilterProvidersRequest filter;

  Map<String, dynamic> toJson() => {'sortBy': sortBy, ...filter.toJson()};
}
