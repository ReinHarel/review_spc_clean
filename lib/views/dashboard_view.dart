import 'package:flutter/material.dart';

// Imports for your exact working screens
import 'ai_study_hub_view.dart';
import 'quiz_hub_view.dart';
import 'ai_tutor_view.dart';
import 'study_planner_view.dart';
import 'subject_reviewers_view.dart';
import 'leaderboards_view.dart';
import 'profile_view.dart';
import '../core/module_config.dart';
import '../widgets/custom_app_header.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Toggle this for testing student status — kept in State per requirement.
  final bool _isIrregular = false;
  final String _studentSection = "CS2A-1";

  @override
  Widget build(BuildContext context) {
    // Perf: cache Theme lookups once per build.
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppHeader(
        title: 'ReviewSPC Dashboard',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileView()),
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
                  color: isDark ? cs.primaryContainer : null,
                  gradient: isDark
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF0FBF5), Color(0xFFE1F4E9)],
                        ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Rein! 👋',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? cs.onPrimaryContainer : const Color(0xFF14532D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Let's conquer your study goals today.",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? cs.onPrimaryContainer.withValues(alpha: 0.75)
                                  : const Color(0xFF14532D).withValues(alpha: 0.7),
                            ),
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

              // 📊 STATS CARDS ROW — SingleChildScrollView+Row replaces ListView to avoid Sliver overhead.
              SizedBox(
                height: 90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        theme: theme,
                        label: 'XP Points',
                        value: '1,250',
                        badge: '+50 today',
                        color: Colors.amber,
                        icon: Icons.emoji_events_rounded,
                      ),
                      _buildStatCard(
                        theme: theme,
                        label: 'Study Streak',
                        value: '5 Days',
                        badge: 'Best Record!',
                        color: Colors.orange,
                        icon: Icons.local_fire_department_rounded,
                      ),
                      _buildStatCard(
                        theme: theme,
                        label: 'Avg Score',
                        value: '82%',
                        badge: '▲ +3%',
                        color: Colors.blue,
                        icon: Icons.show_chart_rounded,
                      ),
                      _buildStatCard(
                        theme: theme,
                        label: 'Quizzes Done',
                        value: '4/5',
                        badge: '1 left today',
                        color: Colors.purple,
                        icon: Icons.menu_book_rounded,
                      ),
                      _buildStatCard(
                        theme: theme,
                        label: 'Time Spent',
                        value: '1.5 hrs',
                        badge: 'Target: 2 hrs',
                        color: Colors.teal,
                        icon: Icons.timer_rounded,
                      ),
                    ],
                  ),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONTINUE LEARNING',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
                          ),
                          SizedBox(height: 6),
                          // Flexible ensures long titles wrap without overflow.
                          Text(
                            'Accounting 101: Balance Sheets',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Chapter 3 • 80% completed',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.cardColor,
                        foregroundColor: const Color(0xFF1E5E2F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SubjectReviewersView()),
                        );
                      },
                      child: const Text('Resume', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 📚 MODULES GRID — 6 unique palettes, solid white-on-accent dark icons
              Text(
                'Study & Review Modules',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              // Perf: Wrap + LayoutBuilder replaces GridView.count(shrinkWrap) double-measure.
              LayoutBuilder(
                builder: (context, constraints) {
                  // 2 columns with 16 spacing → item width = (maxWidth - 16)/2
                  final double itemWidth = (constraints.maxWidth - 16) / 2;
                  // Height derived from 1.35 aspect → height = width / 1.35
                  final double itemHeight = itemWidth / 1.35;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: ModuleConfigs.all.map((config) {
                      return SizedBox(
                        width: itemWidth,
                        height: itemHeight,
                        child: _buildModuleTile(
                          theme: theme,
                          config: config,
                          isDark: isDark,
                          onTap: () {
                            final Widget dest = switch (config.id) {
                              ModuleId.aiHub => const AiStudyHubView(),
                              ModuleId.quiz => const QuizHubView(),
                              ModuleId.tutor => const AiTutorView(),
                              ModuleId.planner => const StudyPlannerView(),
                              ModuleId.reviewers => const SubjectReviewersView(),
                              ModuleId.leaderboards => const LeaderboardsView(),
                            };
                            Navigator.push(context, MaterialPageRoute(builder: (_) => dest));
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required String label,
    required String value,
    required String badge,
    required Color color,
    required IconData icon,
  }) {
    return RepaintBoundary(
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
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
                    color: color.withValues(alpha: 0.1),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModuleTile({
    required ThemeData theme,
    required ModuleConfig config,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    if (isDark) {
      // High-contrast dark: solid accent badge + white icon (glow), tighter shadow.
      return RepaintBoundary(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  config.darkAccent.withValues(alpha: 0.16),
                  theme.cardColor,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: config.darkAccent.withValues(alpha: 0.65),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: config.darkAccent.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Solid accent background + white icon → WCAG AAA contrast.
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: config.darkAccent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                        boxShadow: [
                          BoxShadow(
                            color: config.darkAccent.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        config.icon,
                        color: Colors.white,
                        size: 22,
                        semanticLabel: config.title,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          config.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Light mode — tinted bg + dark icon for contrast.
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: config.lightBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: config.lightBg),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: config.lightBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      config.icon,
                      color: config.lightIcon,
                      size: 22,
                      semanticLabel: config.title,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        config.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
