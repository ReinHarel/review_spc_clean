import 'package:flutter/material.dart';
import '../core/constants.dart';

class LeaderboardsView extends StatelessWidget {
  const LeaderboardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          '🏆 Hall of Fame & Rankings Coming Soon!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
