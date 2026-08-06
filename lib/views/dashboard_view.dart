import 'package:flutter/material.dart';

import '../core/constants.dart';
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'ai_tutor_view.dart';
import 'leaderboards_view.dart';
import 'study_planner_view.dart';
import 'achievements_view.dart';

/// ────────────────────────────────────────────────────────────────
/// ReviewSPC • Dashboard (Home Screen)
///
/// Displays:
///  • SPCBA Green header with profile, Level & EXP progress bar
///  • Daily Streak / Daily Challenge banner
///  • Quick-access grid to all study tools
///
/// NOTE: All data here is MOCK data for now.
///       Papalitan mamaya ng real data mula sa Firebase Auth/Firestore.
/// ────────────────────────────────────────────────────────────────
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  // ── MOCK DATA (temporary only) ────────────────────────────────
  static const String _displayName = 'Juan Dela Cruz';
  static const int _currentLevel = 5;
  static const int _currentExp = 350;
  static const int _expNeeded = 500;
  static const int _streakDays = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardHeader(
              displayName: _displayName,
              level: _currentLevel,
              currentExp: _currentExp,
              expNeeded: _expNeeded,
            ),
            const SizedBox(height: 20),
            const _StreakBanner(streakDays: _streakDays),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your Study Tools',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildToolsGrid(context),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  /// 2-column grid of quick-access study tool cards.
  Widget _buildToolsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.05,
        children: _ToolItem.items
            .map(
              (tool) => _ToolCard(
                tool: tool,
                onTap: () => _onToolTap(context, tool.title),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Temporary handler until the real screens exist.
  void _onToolTap(BuildContext context, String toolName) {
    Widget? targetScreen;

    if (toolName == 'AI Study Hub') {
      targetScreen = const AiStudyHubView();
    } else if (toolName == 'Quiz & Flashcards') {
      targetScreen = const QuizHubView();
    } else if (toolName == 'AI Tutor') {
      targetScreen = const AiTutorView();
    } else if (toolName == 'Leaderboards') {
      targetScreen = const LeaderboardsView();
    } else if (toolName == 'Study Planner') {
      targetScreen = const StudyPlannerView();
    } else if (toolName == 'Achievements') {
      targetScreen = const AchievementsView();
    }

    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      );
    }
  }
}

/// ────────────────────────────────────────────────────────────────
/// Green header: profile info, Level badge, EXP progress bar.
/// ────────────────────────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.displayName,
    required this.level,
    required this.currentExp,
    required this.expNeeded,
  });

  final String displayName;
  final int level;
  final int currentExp;
  final int expNeeded;

  double get _expProgress =>
      expNeeded > 0 ? (currentExp / expNeeded).clamp(0.0, 1.0) : 0.0;

  String get _initials => displayName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0])
      .take(2)
      .join()
      .toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.spcbaGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: AppColors.spcbaGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'LV $level',
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _expProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accentGold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$currentExp / $expNeeded EXP',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Text(
                    '${(_expProgress * 100).toInt()}% to LV ${level + 1}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
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

/// ────────────────────────────────────────────────────────────────
/// Gold banner: Daily Streak + Daily Challenge.
/// ────────────────────────────────────────────────────────────────
class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accentGold, Color(0xFFFF8F00)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59FF8F00),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.whatshot, color: Colors.white, size: 38),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays-Day Streak!',
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Daily Challenge: finish 1 quiz today 🔥',
                    style: TextStyle(color: AppColors.textDark, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.spcbaGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to today's challenge (Quiz Hub)
                },
                child: const Text(
                  'GO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────
/// Model + card for the quick-access study tools grid.
/// ────────────────────────────────────────────────────────────────
class _ToolItem {
  const _ToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;

  static const List<_ToolItem> items = [
    _ToolItem(
      icon: Icons.auto_awesome_rounded,
      title: 'AI Study Hub',
      subtitle: 'Upload PDF / photos',
      tint: Color(0x1A1B5E20),
    ),
    _ToolItem(
      icon: Icons.quiz_rounded,
      title: 'Quiz & Flashcards',
      subtitle: 'Train your brain',
      tint: Color(0x1AFFB300),
    ),
    _ToolItem(
      icon: Icons.emoji_events_rounded,
      title: 'Leaderboards',
      subtitle: 'Hall of Fame',
      tint: Color(0x1AFF8F00),
    ),
    _ToolItem(
      icon: Icons.calendar_month_rounded,
      title: 'Study Planner',
      subtitle: 'Calendar & exams',
      tint: Color(0x1A0288D1),
    ),
    _ToolItem(
      icon: Icons.smart_toy_rounded,
      title: 'AI Tutor',
      subtitle: 'Chat & learn',
      tint: Color(0x1A7B1FA2),
    ),
    // 6th card to balance the 2-column grid (part of gamification too)
    _ToolItem(
      icon: Icons.military_tech_rounded,
      title: 'Achievements',
      subtitle: 'Badges & rewards',
      tint: Color(0x1A00796B),
    ),
  ];
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool, required this.onTap});

  final _ToolItem tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tool.tint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(tool.icon, color: AppColors.spcbaGreen, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                tool.title,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                tool.subtitle,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
