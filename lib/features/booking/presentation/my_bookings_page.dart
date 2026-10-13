import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/presentation/bloc/my_bookings_bloc.dart';
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
      child: Scaffold(
        appBar: AppBar(title: const Text('My bookings')),
        body: BlocBuilder<MyBookingsBloc, MyBookingsState>(
          builder: (context, state) => switch (state) {
            MyBookingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),

            MyBookingsError error => Center(child: Text(error.message)),

            MyBookingsLoaded loaded =>
              loaded.bookings.isEmpty
                  ? const Center(child: Text('No bookings yet'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: loaded.bookings.length,
                      itemBuilder: (_, i) {
                        final booking = loaded.bookings[i];
                        return _BookingCard(
                          booking: booking,
                          provider: loaded.providers[booking.providerId],
                        );
                      },
                    ),
          },
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.provider});

  final BookingEntity booking;
  final ProviderEntity? provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(
      context,
    ).formatMediumDate(booking.date);
    final hours = booking.estimatedHours;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    provider?.name ?? 'Unknown provider',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(booking.id, style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: '$date · ${booking.timeSlot.label}',
            ),
            _InfoRow(
              icon: Icons.timelapse,
              text: '$hours ${hours == 1 ? 'hour' : 'hours'}',
            ),
            _InfoRow(icon: Icons.home_outlined, text: booking.address),
          ],
        ),
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
