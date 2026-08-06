import 'package:flutter/material.dart';
import 'views/dashboard_view.dart';

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
      home: const DashboardView(),
    );
  }
}
