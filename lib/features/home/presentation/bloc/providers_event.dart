part of 'providers_bloc.dart';

class ProvidersEvent {
  const ProvidersEvent();
}

final class LoadProviders extends ProvidersEvent {
  const LoadProviders(this.categoryId);

  final String categoryId;
}
