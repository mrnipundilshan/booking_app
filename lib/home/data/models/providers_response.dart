import 'package:booking_app/home/domain/entities/provider_entity.dart';

class ProviderModel extends ProviderEntity {
  const ProviderModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.rating,
    required super.reviewCount,
    required super.completedJobs,
    required super.experienceYears,
    required super.hourlyRate,
    required super.location,
    required super.isAvailable,
    required super.description,
    required super.skills,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      completedJobs: (json['completedJobs'] as num).toInt(),
      experienceYears: (json['experienceYears'] as num).toInt(),
      hourlyRate: (json['hourlyRate'] as num).toInt(),
      location: json['location'] as String,
      isAvailable: json['isAvailable'] as bool,
      description: json['description'] as String,
      skills: (json['skills'] as List).cast<String>(),
    );
  }
}

class ProvidersResponse {
  const ProvidersResponse({required this.providers});

  final List<ProviderModel> providers;

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) {
    return ProvidersResponse(
      providers: (json['providers'] as List)
          .map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
