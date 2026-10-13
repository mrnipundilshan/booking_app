part of 'jobs_bloc.dart';

class JobsEvent {
  const JobsEvent();
}

final class LoadJobs extends JobsEvent {
  const LoadJobs();
}

final class JobsChanged extends JobsEvent {
  const JobsChanged();
}

final class JobActionRequested extends JobsEvent {
  const JobActionRequested(this.bookingId, this.action);

  final String bookingId;

  final ProviderAction action;
}
