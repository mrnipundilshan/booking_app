part of 'providers_bloc.dart';

sealed class AllProvidersState {
  const AllProvidersState();
}

final class AllProvidersLoading extends AllProvidersState {
  const AllProvidersLoading();
}

final class AllProvidersLoaded extends AllProvidersState {
  const AllProvidersLoaded(this.providers);

  final List<ProviderEntity> providers;
}

final class AllProvidersError extends AllProvidersState {
  const AllProvidersError(this.message);

  final String message;
}
