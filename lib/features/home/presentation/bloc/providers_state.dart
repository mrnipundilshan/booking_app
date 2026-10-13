part of 'providers_bloc.dart';

sealed class ProvidersState {
  const ProvidersState();
}

final class ProvidersLoading extends ProvidersState {
  const ProvidersLoading();
}

final class ProvidersLoaded extends ProvidersState {
  const ProvidersLoaded(this.providers);

  final List<ProviderEntity> providers;
}

final class ProvidersError extends ProvidersState {
  const ProvidersError(this.message);

  final String message;
}
