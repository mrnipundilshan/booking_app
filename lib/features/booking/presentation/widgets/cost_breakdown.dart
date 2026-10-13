import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:flutter/material.dart';

String formatLkr(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return 'LKR $whole.${parts[1]}';
}

class CostBreakdown extends StatelessWidget {
  const CostBreakdown({
    super.key,
    required this.hourlyRate,
    required this.hours,
    required this.cost,
  });

  final int hourlyRate;
  final int hours;
  final BookingCost cost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (BookingCost.weekendSurchargeRate * 100).round();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost breakdown', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _CostRow(
              label: 'Labour',
              detail:
                  '${formatLkr(hourlyRate.toDouble())} × $hours '
                  '${hours == 1 ? 'hour' : 'hours'}',
              amount: formatLkr(cost.labour),
            ),
            _CostRow(
              label: 'Visiting charge',
              detail: 'Fixed',
              amount: formatLkr(cost.visitingCharge),
            ),
            _CostRow(
              label: 'Weekend surcharge',
              detail: '$percent% of labour, Saturdays only',
              amount: formatLkr(cost.weekendSurcharge),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text('Total', style: theme.textTheme.titleMedium),
                ),
                Text(formatLkr(cost.total), style: theme.textTheme.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.detail,
    required this.amount,
  });

  final String label;
  final String detail;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text(amount),
        ],
      ),
    );
  }
}
