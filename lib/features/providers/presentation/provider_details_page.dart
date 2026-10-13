import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/core/common/widgets/availability_badge.dart';
import 'package:booking_app/features/booking/presentation/booking_page.dart';
import 'package:flutter/material.dart';

class ProviderDetailsPage extends StatelessWidget {
  const ProviderDetailsPage({super.key, required this.provider});

  final ProviderEntity provider;

  static Route<void> route(ProviderEntity provider) => MaterialPageRoute(
    builder: (_) => ProviderDetailsPage(provider: provider),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider details')),
      body: _Details(provider: provider),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.provider});

  final ProviderEntity provider;

  String get _category => provider.categoryId
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(provider.name, style: theme.textTheme.titleLarge),
            ),
            AvailabilityBadge(isAvailable: provider.isAvailable),
          ],
        ),
        const SizedBox(height: 4),
        Text(_category, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        _InfoRow(
          icon: Icons.star,
          text:
              '${provider.rating.toStringAsFixed(1)} '
              '(${provider.reviewCount} reviews)',
        ),
        _InfoRow(
          icon: Icons.task_alt,
          text: '${provider.completedJobs} completed jobs',
        ),
        _InfoRow(
          icon: Icons.workspace_premium_outlined,
          text: '${provider.experienceYears} years experience',
        ),
        _InfoRow(
          icon: Icons.payments_outlined,
          text: 'LKR ${provider.hourlyRate}/hr',
        ),
        _InfoRow(icon: Icons.location_on_outlined, text: provider.location),
        const SizedBox(height: 16),
        Text('About', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(provider.description),
        const SizedBox(height: 16),
        Text('Skills', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final s in provider.skills) Chip(label: Text(s))],
        ),
        const SizedBox(height: 24),
        if (!provider.isAvailable) ...[
          Text(
            '${provider.name} is currently busy and not accepting bookings.',
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        FilledButton(
          onPressed: provider.isAvailable
              ? () => Navigator.of(context).push(BookingPage.route(provider))
              : null,
          child: const Text('Book Now'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
