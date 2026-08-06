import 'package:flutter/material.dart'; // Palitan ng package:flutter kapag may typo
import '../core/constants.dart';

class StudyPlannerView extends StatelessWidget {
  const StudyPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          '📅 Calendar & Exam Schedule Coming Soon!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
