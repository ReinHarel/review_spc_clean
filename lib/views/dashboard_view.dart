import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'ai_study_hub_view.dart';
import 'ai_tutor_view.dart';
import 'quiz_hub_view.dart';
import 'study_planner_view.dart';
import 'leaderboards_view.dart';
import 'achievements_view.dart';

class DashboardView extends StatelessWidget {
  final String userName;
  final bool isGuest;
  final String studentStatus;

  const DashboardView({
    super.key,
    this.userName = 'Rein',
    this.isGuest = false,
    this.studentStatus = 'Regular',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReviewSPC Dashboard'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Greeting Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, $userName! 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isGuest 
                          ? 'Exploring mode • Guest Access'
                          : '$studentStatus Student • Ready to conquer study goals',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
                if (studentStatus == 'Irregular')
                  Chip(
                    avatar: const Icon(Icons.alt_route, size: 16, color: Colors.orange),
                    label: const Text('Irregular Curriculum', style: TextStyle(fontSize: 11)),
                    backgroundColor: Colors.orange.shade50,
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Dashboard Grid Cards (Existing code continues...)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
              children: [
                _buildDashboardCard(
                  context,
                  title: 'AI Study Hub',
                  subtitle: 'Upload & Summarize Reviewers',
                  icon: Icons.auto_awesome,
                  color: Colors.teal,
                  targetPage: const AiStudyHubView(),
                ),
                _buildDashboardCard(
                  context,
                  title: 'Quiz & Cards',
                  subtitle: 'Flashcards & Practice Tests',
                  icon: Icons.style,
                  color: Colors.amber,
                  targetPage: const QuizHubView(),
                ),
                _buildDashboardCard(
                  context,
                  title: 'AI Tutor',
                  subtitle: 'Chat & Learn 24/7',
                  icon: Icons.smart_toy,
                  color: Colors.purple,
                  targetPage: const AiTutorView(),
                ),
                _buildDashboardCard(
                  context,
                  title: 'Study Planner',
                  subtitle: 'Calendar & Exams',
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                  targetPage: const StudyPlannerView(),
                ),
                _buildDashboardCard(
                  context,
                  title: 'Leaderboards',
                  subtitle: 'XP Ranking & Top SPCians',
                  icon: Icons.emoji_events,
                  color: Colors.orange,
                  targetPage: const LeaderboardsView(),
                ),
                _buildDashboardCard(
                  context,
                  title: 'Achievements',
                  subtitle: 'Badges & Streaks',
                  icon: Icons.stars,
                  color: Colors.pink,
                  targetPage: const AchievementsView(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget targetPage,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}