import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'ai_study_hub_view.dart';
import 'ai_tutor_view.dart';
import 'quiz_hub_view.dart';
import 'study_planner_view.dart';
import 'leaderboards_view.dart';
import 'achievements_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReviewSPC Dashboard'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Text(
              'Welcome back, Rein! 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Let\'s conquer your study goals today.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Navigation Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildNavCard(
                  context,
                  title: 'AI Study Hub',
                  subtitle: 'Upload & Summarize',
                  icon: Icons.auto_awesome,
                  color: Colors.green,
                  targetView: const AiStudyHubView(),
                ),
                _buildNavCard(
                  context,
                  title: 'Quiz & Cards',
                  subtitle: 'Flashcards & Practice',
                  icon: Icons.style,
                  color: Colors.amber.shade800,
                  targetView: const QuizHubView(),
                ),
                _buildNavCard(
                  context,
                  title: 'AI Tutor',
                  subtitle: 'Chat & learn',
                  icon: Icons.smart_toy,
                  color: Colors.purple,
                  targetView: const AiTutorView(),
                ),
                _buildNavCard(
                  context,
                  title: 'Study Planner',
                  subtitle: 'Calendar & exams',
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                  targetView: const StudyPlannerView(),
                ),
                _buildNavCard(
                  context,
                  title: 'Leaderboards',
                  subtitle: 'Hall of Fame',
                  icon: Icons.emoji_events,
                  color: Colors.orange,
                  targetView: const LeaderboardsView(),
                ),
                _buildNavCard(
                  context,
                  title: 'Achievements',
                  subtitle: 'Badges & rewards',
                  icon: Icons.military_tech,
                  color: Colors.teal,
                  targetView: const AchievementsView(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget targetView,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetView),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}