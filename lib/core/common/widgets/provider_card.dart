import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key, required this.provider});

  final ProviderEntity provider;

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
                Text(
                  provider.isAvailable ? 'Available' : 'Unavailable',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${provider.location} • ${provider.experienceYears} yrs'),
            const SizedBox(height: 4),
            Text('★ ${provider.rating} (${provider.reviewCount})'),
            const SizedBox(height: 4),
            Text('Rs. ${provider.hourlyRate}/hr'),
            const SizedBox(height: 8),
            Text(provider.description),
          ],
        ),
      ),
    );
  }
}
