import 'package:flutter/material.dart';

// Imports for your exact working screens
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'ai_tutor_view.dart';
import 'study_planner_view.dart';
import 'subject_reviewers_view.dart';
import 'leaderboards_view.dart';
import 'profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Toggle this for testing student status
  final bool _isIrregular = false; 
  final String _studentSection = "CS2A-1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        title: const Text(
          'ReviewSPC Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 WELCOME BANNER WITH YEAR & SECTION BADGE
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Rein! 👋',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Let's conquer your study goals today.",
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isIrregular ? const Color(0xFFFEF3C7) : const Color(0xFF1E5E2F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _isIrregular ? 'ENROLLMENT' : 'YEAR & SECTION',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: _isIrregular ? const Color(0xFFD97706) : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isIrregular ? 'IRREGULAR' : _studentSection,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isIrregular ? const Color(0xFFB45309) : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: _isIrregular ? const Color(0xFFB45309) : Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📊 STATS CARDS ROW
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard('XP Points', '1,250', '+50 today', Colors.amber, Icons.emoji_events_rounded),
                    _buildStatCard('Study Streak', '5 Days', 'Best Record!', Colors.orange, Icons.local_fire_department_rounded),
                    _buildStatCard('Avg Score', '82%', '▲ +3%', Colors.blue, Icons.show_chart_rounded),
                    _buildStatCard('Quizzes Done', '4/5', '1 left today', Colors.purple, Icons.menu_book_rounded),
                    _buildStatCard('Time Spent', '1.5 hrs', 'Target: 2 hrs', Colors.teal, Icons.timer_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🟢 CONTINUE LEARNING CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E5E2F), Color(0xFF0F381B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CONTINUE LEARNING',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Accounting 101: Balance Sheets',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Chapter 3 • 80% completed',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E5E2F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SubjectReviewersView()),
                        );
                      },
                      child: const Text('Resume', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 📚 MODULES GRID (EXACT 6 CARDS AS PER YOUR DESIGN)
              const Text(
                'Study & Review Modules',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.35,
                children: [
                  _buildModuleTile(
                    'AI Study Hub',
                    'Summaries & notes',
                    Icons.auto_awesome_rounded,
                    const Color(0xFFE0F2FE),
                    const Color(0xFF0284C7),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AiStudyHubView())),
                  ),
                  _buildModuleTile(
                    'Quiz & Flashcards',
                    'Practice & review',
                    Icons.sports_esports_rounded,
                    const Color(0xFFDCFCE7),
                    const Color(0xFF16A34A),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizHubView())),
                  ),
                  _buildModuleTile(
                    'AI Tutor',
                    'Chat & learn',
                    Icons.psychology_rounded,
                    const Color(0xFFF3E8FF),
                    const Color(0xFF9333EA),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AiTutorView())),
                  ),
                  _buildModuleTile(
                    'Study Planner',
                    'Calendar & exams',
                    Icons.calendar_month_rounded,
                    const Color(0xFFF3E8FF),
                    const Color(0xFF9333EA),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyPlannerView())),
                  ),
                  _buildModuleTile(
                    'Subject Reviewers',
                    'Courses & topics',
                    Icons.menu_book_rounded,
                    const Color(0xFFE0F2FE),
                    const Color(0xFF0284C7),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectReviewersView())),
                  ),
                  _buildModuleTile(
                    'Leaderboards',
                    'Ranks & scores',
                    Icons.format_list_numbered_rounded,
                    const Color(0xFFFFEDD5),
                    const Color(0xFFEA580C),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaderboardsView())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String badge, Color color, IconData icon) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildModuleTile(String title, String subtitle, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha:0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}