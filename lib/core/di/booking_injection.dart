import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:booking_app/features/booking/data/datasources/booking_remote_datasource_impl.dart';
import 'package:booking_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:booking_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:booking_app/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/get_booked_slots_usecase.dart';
import 'package:booking_app/features/booking/domain/usecases/get_my_bookings_usecase.dart';
import 'package:booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:booking_app/features/booking/presentation/bloc/my_bookings_bloc.dart';

void initBookingInjection() {
  // data
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );

  // domain
  sl.registerLazySingleton(() => GetBookedSlotsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));

  // presentation
  sl.registerFactory(() => BookingBloc(sl(), sl()));
  sl.registerFactory(() => MyBookingsBloc(sl(), sl()));
}
