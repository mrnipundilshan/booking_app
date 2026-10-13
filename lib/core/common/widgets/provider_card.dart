import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/core/common/widgets/availability_badge.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.provider,
    this.categoryName,
    this.onTap,
  });

  final ProviderEntity provider;

  final String? categoryName;

  final VoidCallback? onTap;

  String get _category =>
      categoryName ??
      provider.categoryId
          .split('_')
          .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  AvailabilityBadge(isAvailable: provider.isAvailable),
                ],
              ),
              const SizedBox(height: 4),
              Text(_category, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(provider.rating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(provider.location)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'LKR ${provider.hourlyRate}/hr',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
