import 'package:booking_app/core/di/home_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupDi() async {
  // features
  initHomeInjection();
}
