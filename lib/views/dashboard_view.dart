import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'progress_view.dart';
import 'leaderboards_view.dart';
import 'ai_tutor_view.dart';
import 'study_planner_view.dart';
import 'achievements_view.dart';
import 'profile_view.dart'; 
import 'subject_reviewers_view.dart';

class DashboardView extends StatefulWidget {
  final String userName;
  final String studentStatus;

  const DashboardView({
    super.key,
    this.userName = 'Rein',
    this.studentStatus = 'Regular',
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedBottomNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReviewSPC Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.spcbaGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.spcbaGreen.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${widget.userName}! 👋',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Let's conquer your study goals today.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.spcbaGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            widget.studentStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Study & Review Modules',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 6 Main Study Modules Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  _buildModuleCard(
                    title: 'AI Study Hub',
                    subtitle: 'Upload PDF / photos',
                    icon: Icons.auto_awesome_rounded,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiStudyHubView()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    title: 'Quiz & Flashcards',
                    subtitle: 'Train your brain',
                    icon: Icons.sports_esports_rounded,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuizHubView()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    title: 'Study Planner',
                    subtitle: 'Calendar & exams',
                    icon: Icons.calendar_month_rounded,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StudyPlannerView()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    title: 'AI Tutor',
                    subtitle: 'Chat & learn',
                    icon: Icons.smart_toy_rounded,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiTutorView()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    title: 'Achievements',
                    subtitle: 'Badges & rewards',
                    icon: Icons.military_tech_rounded,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AchievementsView()),
                      );
                    },
                  ),
                  _buildModuleCard(
                    title: 'Subject Reviewers',
                    subtitle: 'Courses & topics',
                    icon: Icons.menu_book_rounded,
                    color: Colors.blue,
                   onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SubjectReviewersView()),
            );
          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNav,
        selectedItemColor: AppColors.spcbaGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _selectedBottomNav = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressView()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaderboardsView()));
          } else if (index == 3) {
            // STEP 2 UPDATE: Lilipat na sa Profile Screen pag kinlick ang 👤 icon!
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileView()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}