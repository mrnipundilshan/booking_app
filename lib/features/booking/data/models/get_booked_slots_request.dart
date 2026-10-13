class GetBookedSlotsRequest {
  const GetBookedSlotsRequest({required this.providerId, required this.date});

  final String providerId;
  final DateTime date;

  Map<String, dynamic> toJson() => {
    'providerId': providerId,
    'date': date.toIso8601String(),
  };
}
