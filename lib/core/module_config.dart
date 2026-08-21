import 'package:flutter/material.dart';

/// Immutable config for the 6 dashboard study modules.
/// Distinct palettes for scanability — Planner (orange) & Reviewers (amber) are now unique.
enum ModuleId {
  aiHub,
  quiz,
  tutor,
  planner,
  reviewers,
  leaderboards,
}

class ModuleConfig {
  final ModuleId id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color lightBg;
  final Color lightIcon;
  final Color darkAccent;

  const ModuleConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.lightBg,
    required this.lightIcon,
    required this.darkAccent,
  });
}

class ModuleConfigs {
  // Unique light/dark pairs — WCAG optimized for dark solid white-on-accent badges.
  static const aiHub = ModuleConfig(
    id: ModuleId.aiHub,
    title: 'AI Study Hub',
    subtitle: 'Summaries & notes',
    icon: Icons.auto_awesome_rounded,
    lightBg: Color(0xFFE0F2FE), // sky 100
    lightIcon: Color(0xFF0C4A6E), // sky 900 for contrast
    darkAccent: Color(0xFF38BDF8), // sky 400
  );

  static const quiz = ModuleConfig(
    id: ModuleId.quiz,
    title: 'Quiz & Flashcards',
    subtitle: 'Practice & review',
    icon: Icons.sports_esports_rounded,
    lightBg: Color(0xFFDCFCE7), // emerald 100
    lightIcon: Color(0xFF14532D), // emerald 900
    darkAccent: Color(0xFF22C55E), // emerald 500 — distinct from aiHub
  );

  static const tutor = ModuleConfig(
    id: ModuleId.tutor,
    title: 'SPC Tutor',
    subtitle: 'Chat & learn',
    icon: Icons.psychology_rounded,
    lightBg: Color(0xFFF3E8FF), // purple 100
    lightIcon: Color(0xFF581C87), // purple 900
    darkAccent: Color(0xFFA855F7), // purple 500
  );

  static const planner = ModuleConfig(
    id: ModuleId.planner,
    title: 'Study Planner',
    subtitle: 'Calendar & exams',
    icon: Icons.calendar_month_rounded,
    lightBg: Color(0xFFFFF7ED), // orange 50 — distinct from tutor purple
    lightIcon: Color(0xFF7C2D12), // orange 900
    darkAccent: Color(0xFFF97316), // orange 500
  );

  static const reviewers = ModuleConfig(
    id: ModuleId.reviewers,
    title: 'Subject Reviewers',
    subtitle: 'Courses & topics',
    icon: Icons.menu_book_rounded,
    lightBg: Color(0xFFFEF3C7), // amber 100 — distinct from aiHub sky
    lightIcon: Color(0xFF92400E), // amber 900
    darkAccent: Color(0xFFEAB308), // amber 500
  );

  static const leaderboards = ModuleConfig(
    id: ModuleId.leaderboards,
    title: 'Leaderboards',
    subtitle: 'Ranks & scores',
    icon: Icons.format_list_numbered_rounded,
    lightBg: Color(0xFFFFEDD5), // orange 100 (deeper than planner 50)
    lightIcon: Color(0xFF9A3412), // orange 800
    darkAccent: Color(0xFFFB923C), // orange 400
  );

  static const List<ModuleConfig> all = [
    aiHub,
    quiz,
    tutor,
    planner,
    reviewers,
    leaderboards,
  ];
}
