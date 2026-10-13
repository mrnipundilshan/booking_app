class ProviderEntity {
  const ProviderEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    required this.experienceYears,
    required this.hourlyRate,
    required this.location,
    required this.isAvailable,
    required this.description,
    required this.skills,
  });

  final String id;
  final String name;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final int experienceYears;
  final int hourlyRate;
  final String location;
  final bool isAvailable;
  final String description;
  final List<String> skills;
}
