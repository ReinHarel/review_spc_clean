import 'package:flutter/material.dart';

// Gagamitin natin ang EXISTING files sa folder mo:
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'study_planner_view.dart';
import 'ai_tutor_view.dart';
import 'achievements_view.dart';
import 'subject_reviewers_view.dart';
import 'progress_view.dart';
import 'leaderboards_view.dart';
import 'profile_view.dart';

class DashboardView extends StatefulWidget {
  final String? userName;
  final String? studentStatus;

  const DashboardView({
    super.key,
    this.userName,
    this.studentStatus,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final displayName = widget.userName ?? 'Rein';
    final displayStatus = widget.studentStatus ?? 'Regular';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'ReviewSPC Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                );
              },
              child: const Tooltip(
                message: 'Profile & Settings',
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF1E5E2F),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EDE4),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD3E2CE)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, $displayName! 👋',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Let's conquer your study goals today.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E5E2F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                displayStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Study & Review Modules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Grid ng Action Cards -> Tuturo na sa mga Tamang Existing Views mo!
                  GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.4 : 1.1,
                    children: [
                      // 1. AI Study Hub -> Nakaturo na sa AiStudyHubView()
                      _buildModuleCard(
                        title: 'AI Study Hub',
                        subtitle: 'Upload PDF / photos',
                        icon: Icons.auto_awesome_rounded,
                        iconColor: const Color(0xFF1E88E5),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFD2E3D0),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiStudyHubView())),
                      ),

                      // 2. Quiz & Flashcards -> Nakaturo sa QuizHubView()
                      _buildModuleCard(
                        title: 'Quiz & Flashcards',
                        subtitle: 'Train your brain',
                        icon: Icons.sports_esports_rounded,
                        iconColor: const Color(0xFF2E7D32),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFD2E3D0),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHubView())),
                      ),

                      // 3. Study Planner -> Nakaturo sa StudyPlannerView()
                      _buildModuleCard(
                        title: 'Study Planner',
                        subtitle: 'Calendar & exams',
                        icon: Icons.calendar_month_rounded,
                        iconColor: const Color(0xFF5E35B1),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFDDD2E8),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyPlannerView())),
                      ),

                      // 4. AI Tutor -> Nakaturo sa AiTutorView()
                      _buildModuleCard(
                        title: 'AI Tutor',
                        subtitle: 'Chat & learn',
                        icon: Icons.smart_toy_rounded,
                        iconColor: const Color(0xFF8E24AA),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFE7D0E8),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiTutorView())),
                      ),

                      // 5. Achievements -> Nakaturo sa AchievementsView()
                      _buildModuleCard(
                        title: 'Achievements',
                        subtitle: 'Badges & rewards',
                        icon: Icons.military_tech_rounded,
                        iconColor: const Color(0xFFF57C00),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFFCE4EC),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsView())),
                      ),

                      // 6. Subject Reviewers -> Nakaturo sa SubjectReviewersView()
                      _buildModuleCard(
                        title: 'Subject Reviewers',
                        subtitle: 'Courses & topics',
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFF0288D1),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFD0E7F5),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectReviewersView())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xFF1E5E2F),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: const Color(0xFFEFEFE7),
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressView()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardsView()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}