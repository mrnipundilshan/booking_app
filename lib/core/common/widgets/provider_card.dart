import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key, required this.provider, this.categoryName});

  final ProviderEntity provider;

  final String? categoryName;

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
                _AvailabilityBadge(isAvailable: provider.isAvailable),
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
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Busy',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
