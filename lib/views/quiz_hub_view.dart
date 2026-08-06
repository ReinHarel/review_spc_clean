import 'package:flutter/material.dart';
import '../core/constants.dart';

class QuizHubView extends StatelessWidget {
  const QuizHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz & Flashcards'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          '🧠 Interactive Quizzes & Swipe Cards Coming Soon!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
