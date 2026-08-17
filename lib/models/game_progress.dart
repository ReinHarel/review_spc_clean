import 'package:flutter/material.dart';

/// Shared badge definition used by the Achievements, Profile, and
/// Leaderboards screens. All unlock state and progress lives in
/// [GameProgressStore] so every view renders the same data.
class BadgeData {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final String unlockedDate;
  final double progress;
  final String currentProgressText;
  final String category;

  const BadgeData({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.unlockedDate,
    required this.progress,
    required this.currentProgressText,
    required this.category,
  });

  BadgeData copyWith({
    bool? isUnlocked,
    String? unlockedDate,
    double? progress,
    String? currentProgressText,
  }) {
    return BadgeData(
      title: title,
      desc: desc,
      icon: icon,
      color: color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      progress: progress ?? this.progress,
      currentProgressText: currentProgressText ?? this.currentProgressText,
      category: category,
    );
  }
}

/// Snapshot of the student's level, XP, and badge collection.
class GameProgress {
  final int level;
  final String levelTitle;
  final int xp;
  final int xpToNext;
  final List<BadgeData> badges;

  const GameProgress({
    required this.level,
    required this.levelTitle,
    required this.xp,
    required this.xpToNext,
    required this.badges,
  });

  int get unlockedCount => badges.where((b) => b.isUnlocked).length;
  int get totalBadges => badges.length;
  double get xpProgress => (xp / xpToNext).clamp(0.0, 1.0).toDouble();
  List<BadgeData> get unlockedBadges => badges.where((b) => b.isUnlocked).toList();

  GameProgress copyWith({
    int? level,
    String? levelTitle,
    int? xp,
    int? xpToNext,
    List<BadgeData>? badges,
  }) {
    return GameProgress(
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      xp: xp ?? this.xp,
      xpToNext: xpToNext ?? this.xpToNext,
      badges: badges ?? this.badges,
    );
  }
}

/// Singleton shared state for the current student's progress.
/// Extends [ChangeNotifier] so views can rebuild via [ListenableBuilder].
class GameProgressStore extends ChangeNotifier {
  GameProgressStore._();

  static final GameProgressStore instance = GameProgressStore._();

  GameProgress _progress = const GameProgress(
    level: 4,
    levelTitle: 'Level 4 Scholar',
    xp: 1250,
    xpToNext: 2000,
    badges: [
      BadgeData(
        title: 'First Steps',
        desc: 'Completed your very first quiz.',
        icon: Icons.stars_rounded,
        color: Colors.teal,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 2, 2026',
        progress: 1.0,
        currentProgressText: '1/1 Quiz',
        category: 'Milestone',
      ),
      BadgeData(
        title: 'Early Bird',
        desc: 'Completed a study session before 8:00 AM.',
        icon: Icons.wb_sunny_rounded,
        color: Colors.amber,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 3, 2026',
        progress: 1.0,
        currentProgressText: '1/1 Early Session',
        category: 'Habit',
      ),
      BadgeData(
        title: '7-Day Streak',
        desc: 'Studied for 7 consecutive days without breaking your streak.',
        icon: Icons.local_fire_department_rounded,
        color: Colors.orange,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 5, 2026',
        progress: 1.0,
        currentProgressText: '7/7 Days',
        category: 'Streak',
      ),
      BadgeData(
        title: 'Quiz Master',
        desc: 'Scored a perfect 100% score on 5 different AI Quizzes.',
        icon: Icons.psychology_rounded,
        color: Colors.purple,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 8, 2026',
        progress: 1.0,
        currentProgressText: '5/5 Quizzes',
        category: 'Academic',
      ),
      BadgeData(
        title: 'AI Whisperer',
        desc: 'Generated 20 customized flashcards using AI Study Hub.',
        icon: Icons.auto_awesome_rounded,
        color: Colors.amber,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 9, 2026',
        progress: 1.0,
        currentProgressText: '20/20 Cards',
        category: 'Academic',
      ),
      BadgeData(
        title: 'Speed Demon',
        desc: 'Completed a quiz in under 2 minutes.',
        icon: Icons.bolt_rounded,
        color: Colors.cyan,
        isUnlocked: true,
        unlockedDate: 'Unlocked Aug 10, 2026',
        progress: 1.0,
        currentProgressText: '1/1 Fast Quiz',
        category: 'Academic',
      ),
      BadgeData(
        title: 'Accuracy Master',
        desc: 'Achieved 90%+ accuracy in 10 quizzes.',
        icon: Icons.fact_check_rounded,
        color: Colors.green,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.6,
        currentProgressText: '6/10 Quizzes',
        category: 'Academic',
      ),
      BadgeData(
        title: 'Flashcard Fanatic',
        desc: 'Reviewed 100 flashcards in total.',
        icon: Icons.style_rounded,
        color: Colors.pinkAccent,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.4,
        currentProgressText: '40/100 Cards',
        category: 'Habit',
      ),
      BadgeData(
        title: 'Century Club',
        desc: 'Reached 100 total study hours.',
        icon: Icons.schedule_rounded,
        color: Colors.blue,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.25,
        currentProgressText: '25/100 Hours',
        category: 'Milestone',
      ),
      BadgeData(
        title: 'Night Owl',
        desc: 'Completed an intensive study review past 10:00 PM.',
        icon: Icons.nights_stay_rounded,
        color: Colors.indigo,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.6,
        currentProgressText: '3/5 Late Sessions',
        category: 'Habit',
      ),
      BadgeData(
        title: 'Upload Champ',
        desc: 'Uploaded and processed 10 reviewer documents.',
        icon: Icons.cloud_upload_rounded,
        color: Colors.teal,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.4,
        currentProgressText: '4/10 Files',
        category: 'Upload',
      ),
      BadgeData(
        title: 'Pomodoro Master',
        desc: 'Accumulated a total of 10 hours in Focus Sessions.',
        icon: Icons.timer_rounded,
        color: Colors.redAccent,
        isUnlocked: false,
        unlockedDate: 'Locked',
        progress: 0.8,
        currentProgressText: '8/10 Hours',
        category: 'Habit',
      ),
    ],
  );

  GameProgress get progress => _progress;

  void unlockBadge(String title) {
    final updated = _progress.badges
        .map((b) => b.title == title && !b.isUnlocked
            ? b.copyWith(
                isUnlocked: true,
                unlockedDate: 'Unlocked Just now',
                progress: 1.0,
              )
            : b)
        .toList();
    _progress = _progress.copyWith(badges: updated);
    notifyListeners();
  }

  void addXp(int amount) {
    _progress = _progress.copyWith(xp: _progress.xp + amount);
    notifyListeners();
  }
}