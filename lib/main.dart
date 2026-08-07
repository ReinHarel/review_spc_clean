import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'views/login_view.dart';

void main() {
  runApp(const ReviewSPCApp());
}

class ReviewSPCApp extends StatelessWidget {
  const ReviewSPCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviewSPC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.spcbaGreen),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}