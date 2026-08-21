import 'package:flutter/material.dart';
import 'dashboard_view.dart';

/// Alias wrapper for prompt compatibility — keeps home_view intact
/// without breaking existing routes that use DashboardView.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => const DashboardView();
}
