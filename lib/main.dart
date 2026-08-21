import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'theme_controller.dart';
import 'views/login_view.dart';

void main() {
  runApp(const ReviewSPCApp());
}

class ReviewSPCApp extends StatelessWidget {
  const ReviewSPCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'ReviewSPC',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        home: const LoginView(),
      ),
    );
  }
}
