import 'dart:async';

import 'package:booking_app/core/common/entities/current_provider.dart';
import 'package:booking_app/core/common/entities/provider_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';
import 'package:booking_app/features/booking/domain/entities/jobs_summary.dart';
import 'package:booking_app/features/booking/domain/entities/provider_action.dart';
import 'package:booking_app/features/booking/domain/usecases/apply_provider_action_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/get_provider_jobs_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/watch_booking_changes_usecase.dart';
import 'package:booking_app/features/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetProviderJobsUseCase _getProviderJobs;

  final GetAllProvidersUseCase _getAllProviders;

  final ApplyProviderActionUseCase _applyProviderAction;

  late final StreamSubscription<void> _changes;

  JobsBloc(
    this._getProviderJobs,
    this._getAllProviders,
    this._applyProviderAction,
    WatchBookingChangesUseCase watchChanges,
  ) : super(const JobsLoading()) {
    on<LoadJobs>(_onLoad);
    on<JobsChanged>(_onChanged);
    on<JobActionRequested>(_onAction);
    _changes = watchChanges().listen((_) => add(const JobsChanged()));
  }

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }

  Future<void> _onLoad(LoadJobs event, Emitter<JobsState> emit) async {
    emit(const JobsLoading());
    try {
      final (jobs, providers) = await (
        _getProviderJobs(CurrentProvider.id),
        _getAllProviders(),
      ).wait;
      final provider = providers.firstWhere((p) => p.id == CurrentProvider.id);
      emit(_loaded(jobs, provider: provider));
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }

  Future<void> _onChanged(JobsChanged event, Emitter<JobsState> emit) async {
    if (state is! JobsLoaded) return;
    try {
      final jobs = await _getProviderJobs(CurrentProvider.id);
      final latest = state;
      if (latest is! JobsLoaded) return;
      emit(
        _loaded(jobs, provider: latest.provider, updatingId: latest.updatingId),
      );
    } catch (_) {}
  }

  Future<void> _onAction(
    JobActionRequested event,
    Emitter<JobsState> emit,
  ) async {
    final current = state;
    if (current is! JobsLoaded || current.updatingId != null) return;

    emit(current.copyWith(updatingId: event.bookingId));
    try {
      final updated = await _applyProviderAction(
        providerId: CurrentProvider.id,
        bookingId: event.bookingId,
        action: event.action,
      );
      emit(
        _loaded(
          [
            for (final job in current.groups.values.expand((g) => g))
              job.id == updated.id ? updated : job,
          ],
          provider: current.provider,
          message: 'Job ${updated.id} is now ${updated.status.label}',
        ),
      );
    } catch (e) {
      final latest = state;
      if (latest is JobsLoaded) emit(latest.copyWith(message: e.toString()));
    }
  }

  JobsLoaded _loaded(
    List<BookingEntity> jobs, {
    required ProviderEntity provider,
    String? updatingId,
    String? message,
  }) {
    return JobsLoaded(
      groups: {
        for (final status in BookingStatus.values)
          if (jobs.any((j) => j.status == status))
            status: jobs.where((j) => j.status == status).toList()
              ..sort((a, b) => a.startsAt.compareTo(b.startsAt)),
      },
      summary: JobsSummary.from(jobs, hourlyRate: provider.hourlyRate),
      provider: provider,
      updatingId: updatingId,
      message: message,
    );
  }
}
