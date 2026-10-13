import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/presentation/widgets/cost_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({
    super.key,
    required this.provider,
    required this.booking,
  });

  final ProviderEntity provider;
  final BookingEntity booking;

  static Route<void> route(ProviderEntity provider, BookingEntity booking) =>
      MaterialPageRoute(
        builder: (_) =>
            BookingConfirmationPage(provider: provider, booking: booking),
      );

  void _done(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(context).formatFullDate(booking.date);
    final cost = BookingCost.calculate(
      hourlyRate: provider.hourlyRate,
      hours: booking.estimatedHours,
      date: booking.date,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _done(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking confirmed'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(
              Icons.check_circle,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Your booking is confirmed',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _BookingIdCard(id: booking.id),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking summary', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      icon: Icons.handyman_outlined,
                      label: 'Provider',
                      value: provider.name,
                    ),
                    _SummaryRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: date,
                    ),
                    _SummaryRow(
                      icon: Icons.schedule,
                      label: 'Time slot',
                      value: booking.timeSlot.label,
                    ),
                    _SummaryRow(
                      icon: Icons.timelapse,
                      label: 'Estimated hours',
                      value:
                          '${booking.estimatedHours} '
                          '${booking.estimatedHours == 1 ? 'hour' : 'hours'}',
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      icon: Icons.person_outline,
                      label: 'Customer',
                      value: booking.customerName,
                    ),
                    _SummaryRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: booking.phone,
                    ),
                    _SummaryRow(
                      icon: Icons.home_outlined,
                      label: 'Address',
                      value: booking.address,
                    ),
                    _SummaryRow(
                      icon: Icons.description_outlined,
                      label: 'Job description',
                      value: booking.description,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CostBreakdown(
              hourlyRate: provider.hourlyRate,
              hours: booking.estimatedHours,
              cost: cost,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _done(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingIdCard extends StatelessWidget {
  const _BookingIdCard({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.primaryContainer,
      child: ListTile(
        title: Text(
          'Booking ID',
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
        subtitle: SelectableText(
          id,
          style: theme.textTheme.titleLarge?.apply(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Copy booking ID',
          icon: const Icon(Icons.copy),
          color: theme.colorScheme.onPrimaryContainer,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: id));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Booking ID copied')));
          },
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
