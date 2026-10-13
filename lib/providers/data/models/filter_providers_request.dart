class FilterProvidersRequest {
  const FilterProvidersRequest({
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

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'minRating': minRating,
    'minRate': minRate,
    'maxRate': maxRate,
    'availableOnly': availableOnly,
  };
}
