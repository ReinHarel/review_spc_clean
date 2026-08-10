import 'package:flutter/material.dart';
import 'study_planner_view.dart';
import 'ai_tutor_view.dart';
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'subject_reviewers_view.dart';
import 'leaderboards_view.dart';
import 'profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
 

  final List<Map<String, dynamic>> _stats = const [
    {
      'tag': '+50 today',
      'tagColor': Color(0xFFDCFCE7),
      'tagTextColor': Color(0xFF166534),
      'icon': Icons.emoji_events_rounded,
      'iconColor': Colors.amber,
      'value': '1,250',
      'label': 'XP Points',
    },
    {
      'tag': 'Best Record!',
      'tagColor': Color(0xFFFFEDD5),
      'tagTextColor': Color(0xFFC2410C),
      'icon': Icons.local_fire_department_rounded,
      'iconColor': Colors.orangeAccent,
      'value': '5 Days',
      'label': 'Study Streak',
    },
    {
      'tag': '▲ +3%',
      'tagColor': Color(0xFFDBEAFE),
      'tagTextColor': Color(0xFF1E40AF),
      'icon': Icons.show_chart_rounded,
      'iconColor': Colors.redAccent,
      'value': '82%',
      'label': 'Avg Score',
    },
    {
      'tag': '1 left today',
      'tagColor': Color(0xFFF3E8FF),
      'tagTextColor': Color(0xFF6B21A8),
      'icon': Icons.menu_book_rounded,
      'iconColor': Colors.purple,
      'value': '4/5',
      'label': 'Quizzes Done',
    },
    {
      'tag': 'Target: 2 hrs',
      'tagColor': Color(0xFFE0F2FE),
      'tagTextColor': Color(0xFF0369A1),
      'icon': Icons.timer_rounded,
      'iconColor': Colors.blueGrey,
      'value': '1.5 hrs',
      'label': 'Time Spent',
    },
    {
      'tag': '▲ +2 this wk',
      'tagColor': Color(0xFFFFE4E6),
      'tagTextColor': Color(0xFF9F1239),
      'icon': Icons.track_changes_rounded,
      'iconColor': Colors.red,
      'value': '12',
      'label': 'Topics Mastered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'ReviewSPC Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. WELCOME BANNER WITH GRADIENT
                _buildWelcomeBanner(),
                const SizedBox(height: 14),

                // 2. HORIZONTAL STATS CAROUSEL WITH GRADIENT CARDS
                _buildStatsCarousel(),
                const SizedBox(height: 16),

                // 3. CONTINUE LEARNING CARD WITH GRADIENT
                _buildContinueLearningCard(),
                const SizedBox(height: 20),

                const Text(
                  'Study & Review Modules',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                // 4. COMPACT 2-COLUMN GRID (childAspectRatio set to 1.85 for slick height)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.85, 
                  children: [
  // --- ROW 1 ---
  _buildGradientCard(
    context,
    title: 'AI Study Hub',
    subtitle: 'Summaries & notes',
    icon: Icons.auto_awesome_rounded,
    gradientColors: [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)],
    iconBgColor: const Color(0xFFBAE6FD),
    iconColor: const Color(0xFF0284C7),
    targetScreen: const AiStudyHubView(),
  ),
  _buildGradientCard(
    context,
    title: 'Quiz & Flashcards',
    subtitle: 'Practice & review',
    icon: Icons.sports_esports_rounded,
    gradientColors: [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
    iconBgColor: const Color(0xFFBBF7D0),
    iconColor: const Color(0xFF15803D),
    targetScreen: const QuizHubView(),
  ),

  // --- ROW 2 ---
  _buildGradientCard(
    context,
    title: 'AI Tutor',
    subtitle: 'Chat & learn',
    icon: Icons.smart_toy_rounded,
    gradientColors: [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)],
    iconBgColor: const Color(0xFFE9D5FF),
    iconColor: const Color(0xFF9333EA),
    targetScreen: const AiTutorView(),
  ),
  _buildGradientCard(
    context,
    title: 'Study Planner',
    subtitle: 'Calendar & exams',
    icon: Icons.calendar_month_rounded,
    gradientColors: [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)],
    iconBgColor: const Color(0xFFE9D5FF),
    iconColor: const Color(0xFF9333EA),
    targetScreen: const StudyPlannerView(),
  ),

  // --- ROW 3 ---
  _buildGradientCard(
    context,
    title: 'Subject Reviewers',
    subtitle: 'Courses & topics',
    icon: Icons.menu_book_rounded,
    gradientColors: [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)],
    iconBgColor: const Color(0xFFBAE6FD),
    iconColor: const Color(0xFF0284C7),
    targetScreen: const SubjectReviewersView(),
  ),
  _buildGradientCard(
    context,
    title: 'Leaderboards',
    subtitle: 'Ranks & scores',
    icon: Icons.leaderboard_rounded,
    gradientColors: [const Color(0xFFFFFBEE), const Color(0xFFFFEDD5)],
    iconBgColor: const Color(0xFFFED7AA),
    iconColor: const Color(0xFFEA580C),
    targetScreen: const LeaderboardsView(),
  ),
],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Welcome Banner with Gradient
  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F0E6), Color(0xFFD6E8D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Rein! 👋',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Let's conquer your study goals today.",
                style: TextStyle(color: Color(0xFF475569), fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF1E5E2F)],
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Regular',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Swipeable Stats Carousel with subtle gradient cards
  // Compact Horizontal Scrollable Stats List (Displays 5+ cards visible at once)
  Widget _buildStatsCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 105,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _stats.length,
            itemBuilder: (context, index) {
              final item = _stats[index];
              return Container(
                width: 112, // Fixed compact width para magkasya ang 5 cards sabay-sabay!
                margin: EdgeInsets.only(
                  right: index == _stats.length - 1 ? 0 : 10,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFAFAFA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge Tag at Top
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item['tagColor'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['tag'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: item['tagTextColor'],
                        ),
                      ),
                    ),
                    // Value & Icon at Middle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], color: item['iconColor'], size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item['value'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Label at Bottom
                    Text(
                      item['label'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _stats.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              width: index == 0 ? 16 : 4,
              decoration: BoxDecoration(
                color: index == 0 ? const Color(0xFF1E5E2F) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Continue Learning Card with Forest Gradient
  Widget _buildContinueLearningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E5E2F), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5E2F).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTINUE LEARNING',
                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                SizedBox(height: 4),
                Text(
                  'Accounting 101: Balance Sheets',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Chapter 3 • 80% completed',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E5E2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
            child: const Text('Resume', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // Compact Gradient Card Widget
  Widget _buildGradientCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconBgColor,
    required Color iconColor,
    required Widget targetScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                      ),
                    ],
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