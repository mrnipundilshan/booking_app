import 'package:booking_app/base_app.dart';
import 'package:booking_app/core/di/di.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupDi();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('si')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}
