import 'package:flutter/material.dart';

import 'achievements_view.dart';
import 'ai_study_hub_view.dart';
import 'ai_tutor_view.dart';
import 'leaderboards_view.dart';
import 'profile_view.dart';
import 'progress_view.dart';
import 'quiz_hub_view.dart';
import 'study_planner_view.dart';
import 'subject_reviewers_view.dart';

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
  
  // Controller para sa Horizontal Scroll at Indicator Dots
  final ScrollController _scrollController = ScrollController();
  int _activeCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Calculator para malaman kung anong card ang nasa screen
      final double offset = _scrollController.offset;
      final int newIndex = (offset / 140).round().clamp(0, 5);
      if (newIndex != _activeCardIndex) {
        setState(() {
          _activeCardIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  const SizedBox(height: 16),

                  // 📲 INTERACTIVE HORIZONTAL SCROLL CARDS
                  SizedBox(
                    height: 105,
                    child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildInteractiveStatCard(
                          value: '🏆 1,250',
                          label: 'XP Points',
                          trend: '+50 today',
                          trendColor: Colors.green.shade700,
                          valueColor: const Color(0xFF1E5E2F),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardsView())),
                        ),
                        _buildInteractiveStatCard(
                          value: '🔥 5 Days',
                          label: 'Study Streak',
                          trend: 'Best Record!',
                          trendColor: Colors.orange.shade800,
                          valueColor: Colors.orange.shade800,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsView())),
                        ),
                        _buildInteractiveStatCard(
                          value: '📈 82%',
                          label: 'Avg Score',
                          trend: '▲ +3%',
                          trendColor: Colors.blue.shade700,
                          valueColor: Colors.blue.shade700,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressView())),
                        ),
                        _buildInteractiveStatCard(
                          value: '📚 4/5',
                          label: 'Quizzes Done',
                          trend: '1 left today',
                          trendColor: Colors.purple.shade700,
                          valueColor: Colors.purple.shade700,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHubView())),
                        ),
                        _buildInteractiveStatCard(
                          value: '⏱️ 1.5 hrs',
                          label: 'Time Spent',
                          trend: 'Target: 2 hrs',
                          trendColor: Colors.teal.shade700,
                          valueColor: Colors.teal.shade700,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressView())),
                        ),
                        _buildInteractiveStatCard(
                          value: '🎯 12',
                          label: 'Topics Mastered',
                          trend: '▲ +2 this week',
                          trendColor: Colors.amber.shade900,
                          valueColor: Colors.amber.shade900,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectReviewersView())),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔘 PAGE / SCROLL INDICATOR DOTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _activeCardIndex == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _activeCardIndex == index
                              ? const Color(0xFF1E5E2F)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Continue Learning Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5E2F),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CONTINUE LEARNING',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB5E2C5),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Accounting 101: Balance Sheets',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Chapter 3 • 80% completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SubjectReviewersView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E5E2F),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Resume',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

                  // Grid ng Action Cards
                  GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.4 : 1.1,
                    children: [
                      _buildModuleCard(
                        title: 'AI Study Hub',
                        subtitle: 'Upload PDF / photos',
                        icon: Icons.auto_awesome_rounded,
                        iconColor: const Color(0xFF1E88E5),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFD2E3D0),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiStudyHubView())),
                      ),
                      _buildModuleCard(
                        title: 'Quiz & Flashcards',
                        subtitle: 'Train your brain',
                        icon: Icons.sports_esports_rounded,
                        iconColor: const Color(0xFF2E7D32),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFD2E3D0),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHubView())),
                      ),
                      _buildModuleCard(
                        title: 'Study Planner',
                        subtitle: 'Calendar & exams',
                        icon: Icons.calendar_month_rounded,
                        iconColor: const Color(0xFF5E35B1),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFDDD2E8),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyPlannerView())),
                      ),
                      _buildModuleCard(
                        title: 'AI Tutor',
                        subtitle: 'Chat & learn',
                        icon: Icons.smart_toy_rounded,
                        iconColor: const Color(0xFF8E24AA),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFE7D0E8),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiTutorView())),
                      ),
                      _buildModuleCard(
                        title: 'Achievements',
                        subtitle: 'Badges & rewards',
                        icon: Icons.military_tech_rounded,
                        iconColor: const Color(0xFFF57C00),
                        bgColor: const Color(0xFFE8ECE5),
                        iconBg: const Color(0xFFFCE4EC),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsView())),
                      ),
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xFF1E5E2F),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: const Color(0xFFEFEFE7),
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            setState(() => _currentNavIndex = 0);
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressView()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardsView()));
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
        ],
      ),
    );
  }

  // 💡 Custom Widget para sa Interactive Card na may Micro Trend Badge
  Widget _buildInteractiveStatCard({
    required String value,
    required String label,
    required String trend,
    required Color trendColor,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 135,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Micro Trend / Indicator Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
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
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
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