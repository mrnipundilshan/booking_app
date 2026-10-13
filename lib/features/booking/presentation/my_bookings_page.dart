import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/presentation/bloc/my_bookings_bloc.dart';
import 'package:booking_app/features/booking/presentation/widgets/cost_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final _bloc = sl<MyBookingsBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadMyBookings());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: DefaultTabController(
        length: 2,
        child: BlocConsumer<MyBookingsBloc, MyBookingsState>(
          listenWhen: (_, current) =>
              current is MyBookingsLoaded && current.message != null,
          listener: (context, state) {
            final message = (state as MyBookingsLoaded).message!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          builder: (context, state) {
            final counts = state is MyBookingsLoaded ? state : null;
            return Scaffold(
              appBar: AppBar(
                title: const Text('My bookings'),
                bottom: TabBar(
                  tabs: [
                    Tab(text: _tabLabel('Upcoming', counts?.upcoming)),
                    Tab(text: _tabLabel('History', counts?.history)),
                  ],
                ),
              ),
              body: switch (state) {
                MyBookingsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),

                MyBookingsError error => Center(child: Text(error.message)),

                MyBookingsLoaded loaded => TabBarView(
                  children: [
                    _BookingList(
                      bookings: loaded.upcoming,
                      providers: loaded.providers,
                      categoryNames: loaded.categoryNames,
                      cancellingId: loaded.cancellingId,
                      emptyText: 'No upcoming bookings',
                    ),
                    _BookingList(
                      bookings: loaded.history,
                      providers: loaded.providers,
                      categoryNames: loaded.categoryNames,
                      cancellingId: loaded.cancellingId,
                      emptyText: 'No past bookings',
                    ),
                  ],
                ),
              },
            );
          },
        ),
      ),
    );
  }

  String _tabLabel(String title, List<BookingEntity>? bookings) =>
      bookings == null ? title : '$title (${bookings.length})';
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.bookings,
    required this.providers,
    required this.categoryNames,
    required this.cancellingId,
    required this.emptyText,
  });

  final List<BookingEntity> bookings;
  final Map<String, ProviderEntity> providers;
  final Map<String, String> categoryNames;
  final String? cancellingId;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return Center(child: Text(emptyText));
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: bookings.length,
      itemBuilder: (_, i) {
        final booking = bookings[i];
        final provider = providers[booking.providerId];
        return _BookingCard(
          booking: booking,
          provider: provider,
          service: categoryNames[provider?.categoryId],
          isCancelling: booking.id == cancellingId,
          cancelEnabled: cancellingId == null,
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.provider,
    required this.service,
    required this.isCancelling,
    required this.cancelEnabled,
  });

  final BookingEntity booking;
  final ProviderEntity? provider;
  final String? service;
  final bool isCancelling;
  final bool cancelEnabled;

  Future<void> _confirmCancel(BuildContext context, String date) async {
    final bloc = context.read<MyBookingsBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          'Your booking with ${provider?.name ?? 'this provider'} on '
          '$date, ${booking.timeSlot.label} will be cancelled. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep booking'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed == true) bloc.add(CancelBooking(booking.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(
      context,
    ).formatMediumDate(booking.date);
    final provider = this.provider;
    final total = provider == null
        ? null
        : BookingCost.calculate(
            hourlyRate: provider.hourlyRate,
            hours: booking.estimatedHours,
            date: booking.date,
          ).total;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider?.name ?? 'Unknown provider',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        service ?? 'Unknown service',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.calendar_today_outlined, text: date),
            _InfoRow(icon: Icons.schedule, text: booking.timeSlot.label),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(booking.id, style: theme.textTheme.bodySmall),
                ),
                Text(
                  total == null ? '—' : formatLkr(total),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            if (isCancelling || booking.canCancel(DateTime.now())) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: cancelEnabled
                      ? () => _confirmCancel(context, date)
                      : null,
                  icon: isCancelling
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.close),
                  label: Text(isCancelling ? 'Cancelling…' : 'Cancel booking'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (status) {
      BookingStatus.pending => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      BookingStatus.confirmed => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      BookingStatus.inProgress => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      BookingStatus.completed => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      BookingStatus.cancelled || BookingStatus.rejected => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
