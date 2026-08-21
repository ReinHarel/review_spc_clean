import 'package:flutter/material.dart';

/// Simple in-memory app theme controller.
/// Persistence is intentionally omitted.
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static void setDark(bool dark) {
    mode.value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}