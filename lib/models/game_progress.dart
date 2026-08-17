import 'dart:math';

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
  final int quizzesCompleted;
  final int perfectQuizzes;
  final int accuracyMasterCount;
  final List<String> weakConcepts;
  final List<BadgeData> badges;

  const GameProgress({
    required this.level,
    required this.levelTitle,
    required this.xp,
    required this.xpToNext,
    required this.quizzesCompleted,
    required this.perfectQuizzes,
    required this.accuracyMasterCount,
    required this.weakConcepts,
    required this.badges,
  });

  int get unlockedCount => badges.where((b) => b.isUnlocked).length;
  int get totalBadges => badges.length;
  double get xpProgress => (xp / xpToNext).clamp(0.0, 1.0).toDouble();
  List<BadgeData> get unlockedBadges =>
      badges.where((b) => b.isUnlocked).toList();

  GameProgress copyWith({
    int? level,
    String? levelTitle,
    int? xp,
    int? xpToNext,
    int? quizzesCompleted,
    int? perfectQuizzes,
    int? accuracyMasterCount,
    List<String>? weakConcepts,
    List<BadgeData>? badges,
  }) {
    return GameProgress(
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      xp: xp ?? this.xp,
      xpToNext: xpToNext ?? this.xpToNext,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      perfectQuizzes: perfectQuizzes ?? this.perfectQuizzes,
      accuracyMasterCount: accuracyMasterCount ?? this.accuracyMasterCount,
      weakConcepts: weakConcepts ?? this.weakConcepts,
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
    quizzesCompleted: 8,
    perfectQuizzes: 5,
    accuracyMasterCount: 6,
    weakConcepts: ['Data Structures', 'Time Complexity', 'Dynamic Programming'],
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
        .map(
          (b) => b.title == title && !b.isUnlocked
              ? b.copyWith(
                  isUnlocked: true,
                  unlockedDate: 'Unlocked Just now',
                  progress: 1.0,
                )
              : b,
        )
        .toList();
    _progress = _progress.copyWith(badges: updated);
    notifyListeners();
  }

  void addXp(int amount) {
    _progress = _progress.copyWith(xp: _progress.xp + amount);
    notifyListeners();
  }

  List<String> get reviewMistakes => _progress.weakConcepts;

  void addWeakConcept(String concept) {
    final normalized = concept.trim();
    if (normalized.isEmpty) return;

    final existing = _progress.weakConcepts
        .map((value) => value.trim())
        .toList();
    if (existing.any(
      (value) => value.toLowerCase() == normalized.toLowerCase(),
    )) {
      return;
    }

    _progress = _progress.copyWith(weakConcepts: [...existing, normalized]);
    notifyListeners();
  }

  void recordMistake({required String question, List<String>? concepts}) {
    final items = <String>[];
    if (question.trim().isNotEmpty) items.add(question.trim());
    if (concepts != null) {
      for (final concept in concepts) {
        final trimmed = concept.trim();
        if (trimmed.isNotEmpty) items.add(trimmed);
      }
    }

    for (final item in items) {
      addWeakConcept(item);
    }
  }

  void clearWeakConcepts() {
    _progress = _progress.copyWith(weakConcepts: const []);
    notifyListeners();
  }

  // ── Level thresholds ──────────────────────────────────────────────

  static int _xpForNextLevel(int currentLevel) {
    const thresholds = [0, 200, 400, 800, 2000, 3500, 5500, 8000, 12000, 18000];
    if (currentLevel >= 1 && currentLevel < thresholds.length) {
      return thresholds[currentLevel];
    }
    return 999999;
  }

  static String _titleForLevel(int level) {
    const titles = [
      '',
      'Freshman Reviewer',
      'Dedicated Student',
      'Quiz Enthusiast',
      'Level 4 Scholar',
      'Honor Scholar',
      'Master Strategist',
      'Knowledge Titan',
      "Dean's Lister",
      'Grandmaster Reviewer',
      'Valedictorian Elite',
    ];
    return (level >= 1 && level <= 10) ? titles[level] : 'Scholar';
  }

  // ── Quiz completion handler ───────────────────────────────────────

  void recordQuizCompletion({
    required int accuracyPercent,
    required int xpEarned,
    required bool wasUnderTwoMinutes,
    int antiCheatPenalty = 0,
    int antiCheatWarnings = 0,
  }) {
    var p = _progress;

    final int adjustedXpEarned = max(0, xpEarned - antiCheatPenalty);
    final int newQuizzesCompleted = p.quizzesCompleted + 1;
    final int newPerfectQuizzes =
        p.perfectQuizzes + (accuracyPercent == 100 ? 1 : 0);
    final int newAccuracyMasterCount =
        p.accuracyMasterCount + (accuracyPercent >= 90 ? 1 : 0);
    final int newXP = p.xp + adjustedXpEarned;

    // Level-up loop
    int newLevel = p.level;
    int newXPToNext = p.xpToNext;
    while (newXP >= newXPToNext && newLevel < 10) {
      newLevel++;
      newXPToNext = _xpForNextLevel(newLevel);
    }
    final String newLevelTitle = _titleForLevel(newLevel);

    // Badge unlock / progress update
    final updatedBadges = p.badges.map((b) {
      if (b.isUnlocked) return b;

      bool shouldUnlock = false;
      String progressText = b.currentProgressText;
      double progress = b.progress;

      switch (b.title) {
        case 'First Steps':
          progress = (newQuizzesCompleted / 1).clamp(0.0, 1.0);
          progressText = '$newQuizzesCompleted/1 Quiz';
          if (newQuizzesCompleted >= 1) shouldUnlock = true;
          break;
        case 'Quiz Master':
          progress = (newPerfectQuizzes / 5).clamp(0.0, 1.0);
          progressText = '$newPerfectQuizzes/5 Quizzes';
          if (newPerfectQuizzes >= 5) shouldUnlock = true;
          break;
        case 'Speed Demon':
          if (wasUnderTwoMinutes) shouldUnlock = true;
          progress = wasUnderTwoMinutes ? 1.0 : 0.0;
          progressText = wasUnderTwoMinutes ? '1/1 Fast Quiz' : '0/1 Fast Quiz';
          break;
        case 'Accuracy Master':
          progress = (newAccuracyMasterCount / 10).clamp(0.0, 1.0);
          progressText = '$newAccuracyMasterCount/10 Quizzes';
          if (newAccuracyMasterCount >= 10) shouldUnlock = true;
          break;
      }

      if (shouldUnlock) {
        return b.copyWith(
          isUnlocked: true,
          unlockedDate: 'Unlocked Just now',
          progress: 1.0,
          currentProgressText: progressText,
        );
      }
      return b.copyWith(progress: progress, currentProgressText: progressText);
    }).toList();

    _progress = p.copyWith(
      level: newLevel,
      levelTitle: newLevelTitle,
      xp: newXP,
      xpToNext: newXPToNext,
      quizzesCompleted: newQuizzesCompleted,
      perfectQuizzes: newPerfectQuizzes,
      accuracyMasterCount: newAccuracyMasterCount,
      weakConcepts: p.weakConcepts,
      badges: updatedBadges,
    );
    notifyListeners();
  }
}
