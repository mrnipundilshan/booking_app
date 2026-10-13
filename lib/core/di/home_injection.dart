import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/home/data/datasources/home_remote_datasource.dart';
import 'package:booking_app/home/data/datasources/home_remote_datasource_impl.dart';
import 'package:booking_app/home/data/repositories/home_repository_impl.dart';
import 'package:booking_app/home/domain/repositories/home_repository.dart';
import 'package:booking_app/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/home/presentation/bloc/home_bloc.dart';

void initHomeInjection() {
  // data
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));

  // domain
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // presentation
  sl.registerFactory(() => HomeBloc(sl()));
}
