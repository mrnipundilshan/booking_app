import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/providers/data/datasources/providers_remote_datasource.dart';
import 'package:booking_app/features/providers/data/datasources/providers_remote_datasource_impl.dart';
import 'package:booking_app/features/providers/data/repositories/providers_repository_impl.dart';
import 'package:booking_app/features/providers/domain/repositories/providers_repository.dart';
import 'package:booking_app/features/providers/domain/usecases/get_all_providers_usecase.dart';
import 'package:booking_app/features/providers/domain/usecases/sort_providers_usecase.dart';
import 'package:booking_app/features/providers/domain/usecases/filter_providers_usecase.dart';
import 'package:booking_app/features/providers/presentation/bloc/providers_bloc.dart';

void initProvidersInjection() {
  // data
  sl.registerLazySingleton<ProvidersRemoteDataSource>(
    () => const ProvidersRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProvidersRepository>(
    () => ProvidersRepositoryImpl(sl()),
  );

  // domain
  sl.registerLazySingleton(() => GetAllProvidersUseCase(sl()));
  sl.registerLazySingleton(() => FilterProvidersUseCase(sl()));
  sl.registerLazySingleton(() => SortProvidersUseCase(sl()));

  // presentation
  sl.registerFactory(() => AllProvidersBloc(sl(), sl(), sl()));
}
