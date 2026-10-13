part of 'jobs_bloc.dart';

sealed class JobsState {
  const JobsState();
}

final class JobsLoading extends JobsState {
  const JobsLoading();
}

final class JobsLoaded extends JobsState {
  const JobsLoaded({
    required this.groups,
    required this.summary,
    required this.provider,
    this.updatingId,
    this.message,
  });

  final Map<BookingStatus, List<BookingEntity>> groups;

  final JobsSummary summary;

  final ProviderEntity provider;

  final String? updatingId;

  final String? message;

  JobsLoaded copyWith({String? updatingId, String? message}) => JobsLoaded(
    groups: groups,
    summary: summary,
    provider: provider,
    updatingId: updatingId,
    message: message,
  );
}

final class JobsError extends JobsState {
  const JobsError(this.message);

  final String message;
}
