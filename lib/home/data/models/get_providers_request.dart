class GetProvidersRequest {
  const GetProvidersRequest({required this.categoryId});

  final String categoryId;

  Map<String, dynamic> toJson() => {'categoryId': categoryId};
}
