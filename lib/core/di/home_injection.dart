import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:booking_app/features/home/data/datasources/home_remote_datasource_impl.dart';
import 'package:booking_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:booking_app/features/home/domain/repositories/home_repository.dart';
import 'package:booking_app/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/features/home/domain/usecases/get_providers_usecase.dart';
import 'package:booking_app/features/home/domain/usecases/search_providers_usecase.dart';
import 'package:booking_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:booking_app/features/home/presentation/bloc/providers_bloc.dart';

void initHomeInjection() {
  // data
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));

  // domain
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProvidersUseCase(sl()));
  sl.registerLazySingleton(() => SearchProvidersUseCase(sl()));

  // presentation
  sl.registerFactory(() => HomeBloc(sl(), sl()));
  sl.registerFactory(() => ProvidersBloc(sl()));
}
