part of 'providers_bloc.dart';

class AllProvidersEvent {
  const AllProvidersEvent();
}

final class LoadAllProviders extends AllProvidersEvent {
  const LoadAllProviders();
}

final class FilterProviders extends AllProvidersEvent {
  const FilterProviders({
    this.categoryId,
    this.minRating,
    this.minRate,
    this.maxRate,
    this.availableOnly = false,
  });

  final String? categoryId;
  final double? minRating;
  final int? minRate;
  final int? maxRate;
  final bool availableOnly;
}
