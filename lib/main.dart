import 'package:booking_app/base_app.dart';
import 'package:booking_app/core/di/di.dart';
import 'package:flutter/material.dart';

void main() async {
  await setupDi();
  runApp(const MainApp());
}
