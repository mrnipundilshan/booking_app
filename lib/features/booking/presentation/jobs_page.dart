import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/jobs_summary.dart';
import 'package:booking_app/features/booking/domain/entities/provider_action.dart';
import 'package:booking_app/features/booking/presentation/bloc/jobs_bloc.dart';
import 'package:booking_app/features/booking/presentation/widgets/cost_breakdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final _bloc = sl<JobsBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadJobs());
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
        appBar: AppBar(title: Text('jobs.title'.tr(context: context))),
        body: BlocConsumer<JobsBloc, JobsState>(
          listenWhen: (_, current) =>
              current is JobsLoaded && current.message != null,
          listener: (context, state) {
            final message = (state as JobsLoaded).message!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          builder: (context, state) => switch (state) {
            JobsLoading() => const Center(child: CircularProgressIndicator()),

            JobsError error => Center(child: Text(error.message)),

            JobsLoaded loaded => ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _SummaryCard(summary: loaded.summary),
                if (loaded.groups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text('jobs.empty'.tr(context: context)),
                    ),
                  ),
                for (final MapEntry(key: status, value: jobs)
                    in loaded.groups.entries) ...[
                  _GroupHeader(status: status, count: jobs.length),
                  for (final job in jobs)
                    _JobCard(
                      job: job,
                      hourlyRate: loaded.provider.hourlyRate,
                      isUpdating: job.id == loaded.updatingId,
                      actionsEnabled: loaded.updatingId == null,
                    ),
                ],
              ],
            ),
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final JobsSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'jobs.pending_jobs'.tr(context: context),
                value: '${summary.pendingCount}',
              ),
            ),
            Expanded(
              child: _SummaryTile(
                label: 'jobs.total_earnings'.tr(context: context),
                value: formatLkr(summary.totalEarnings),
                caption: 'jobs.earnings_caption'.tr(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value, this.caption});

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge),
        if (caption != null) Text(caption!, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.status, required this.count});

  final BookingStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        '${'status.${status.name}'.tr(context: context)} ($count)',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.job,
    required this.hourlyRate,
    required this.isUpdating,
    required this.actionsEnabled,
  });

  final BookingEntity job;
  final int hourlyRate;
  final bool isUpdating;
  final bool actionsEnabled;

  Future<void> _onAction(
    BuildContext context,
    ProviderAction action,
    String date,
  ) async {
    final bloc = context.read<JobsBloc>();
    if (action == ProviderAction.reject) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('jobs.reject_title'.tr(context: dialogContext)),
          content: Text(
            'jobs.reject_body'.tr(
              context: dialogContext,
              namedArgs: {
                'customer': job.customerName,
                'date': date,
                'slot': job.timeSlot.label,
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('jobs.keep'.tr(context: dialogContext)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('actions.reject'.tr(context: dialogContext)),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    bloc.add(JobActionRequested(job.id, action));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(context).formatMediumDate(job.date);
    final total = BookingCost.calculate(
      hourlyRate: hourlyRate,
      hours: job.estimatedHours,
      date: job.date,
    ).total;
    final actions = ProviderAction.availableFor(job.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.customerName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: '$date, ${job.timeSlot.label}',
            ),
            _InfoRow(
              icon: Icons.timer_outlined,
              text: 'jobs.hours'.plural(job.estimatedHours, context: context),
            ),
            _InfoRow(icon: Icons.phone_outlined, text: job.phone),
            _InfoRow(icon: Icons.place_outlined, text: job.address),
            _InfoRow(icon: Icons.notes, text: job.description),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(child: Text(job.id, style: theme.textTheme.bodySmall)),
                Text(formatLkr(total), style: theme.textTheme.titleSmall),
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (isUpdating)
                const Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final action in actions)
                      _ActionButton(
                        action: action,
                        onPressed: actionsEnabled
                            ? () => _onAction(context, action, date)
                            : null,
                      ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.onPressed});

  final ProviderAction action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = Text('actions.${action.name}'.tr(context: context));
    if (action == ProviderAction.reject) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        onPressed: onPressed,
        child: label,
      );
    }
    return FilledButton(onPressed: onPressed, child: label);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
