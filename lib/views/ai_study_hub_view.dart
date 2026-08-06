import 'package:flutter/material.dart';
import '../core/constants.dart';

class AiStudyHubView extends StatelessWidget {
  const AiStudyHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Hub'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          '📄 PDF / Image Upload Feature Coming Soon!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
