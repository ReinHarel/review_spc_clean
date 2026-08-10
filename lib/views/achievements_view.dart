import 'package:flutter/material.dart';

class AchievementsView extends StatefulWidget {
  const AchievementsView({super.key});

  @override
  State<AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<AchievementsView> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _badges = [
    {
      'title': '7-Day Streak',
      'desc': 'Studied for 7 consecutive days without breaking streak.',
      'icon': Icons.local_fire_department_rounded,
      'color': Colors.orange,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 5, 2026',
      'progress': 1.0,
      'category': 'Streak',
    },
    {
      'title': 'Quiz Master',
      'desc': 'Scored a perfect 100% score on 5 different AI Quizzes.',
      'icon': Icons.psychology_rounded,
      'color': Colors.purple,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 8, 2026',
      'progress': 1.0,
      'category': 'Academic',
    },
    {
      'title': 'Night Owl',
      'desc': 'Completed an intensive study review past 10:00 PM.',
      'icon': Icons.nights_stay_rounded,
      'color': Colors.indigo,
      'isUnlocked': false,
      'unlockedDate': 'Locked',
      'progress': 0.6,
      'currentProgressText': '3/5 Late Sessions',
      'category': 'Habit',
    },
    {
      'title': 'Upload Champ',
      'desc': 'Uploaded and processed 10 reviewer documents.',
      'icon': Icons.cloud_upload_rounded,
      'color': Colors.teal,
      'isUnlocked': false,
      'unlockedDate': 'Locked',
      'progress': 0.4,
      'currentProgressText': '4/10 Files',
      'category': 'Upload',
    },
    {
      'title': 'Pomodoro Master',
      'desc': 'Accumulated a total of 10 hours in Focus Sessions.',
      'icon': Icons.timer_rounded,
      'color': Colors.redAccent,
      'isUnlocked': false,
      'unlockedDate': 'Locked',
      'progress': 0.8,
      'currentProgressText': '8/10 Hours',
      'category': 'Habit',
    },
    {
      'title': 'AI Whisperer',
      'desc': 'Generated 20 customized flashcards using AI Study Hub.',
      'icon': Icons.auto_awesome_rounded,
      'color': Colors.amber,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 9, 2026',
      'progress': 1.0,
      'category': 'Academic',
    },
  ];

  void _showBadgeDialog(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (badge['isUnlocked'] as bool)
                    ? (badge['color'] as Color).withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge['icon'] as IconData,
                size: 52,
                color: (badge['isUnlocked'] as bool)
                    ? (badge['color'] as Color)
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge['title'] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            Text(
              badge['desc'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (badge['isUnlocked'] as bool) ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (badge['isUnlocked'] as bool) ? Colors.green.shade300 : Colors.grey.shade300,
                ),
              ),
              child: Text(
                badge['isUnlocked']
                    ? (badge['unlockedDate'] as String)
                    : (badge['currentProgressText'] ?? 'Locked'),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: (badge['isUnlocked'] as bool) ? Colors.green.shade700 : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _badges.where((b) => b['isUnlocked'] as bool).length;
    final totalBadges = _badges.length;

    final filteredBadges = _badges.where((badge) {
      if (_selectedFilter == 'Unlocked') return badge['isUnlocked'] == true;
      if (_selectedFilter == 'Locked') return badge['isUnlocked'] == false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Achievements & Badges',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
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
                  // 1. LEVEL & XP SUMMARY CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E5E2F), Color(0xFF2E7D32)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E5E2F).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Trophy Level Avatar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 6,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                              ),
                            ),
                            const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white12,
                              child: Icon(Icons.emoji_events_rounded, color: Colors.amberAccent, size: 30),
                            ),
                          ],
                        ),
                        const SizedBox(width: 18),

                        // Stats Detail
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level 4 Scholar 🎓',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '1,250 XP',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$unlockedCount of $totalBadges Badges Unlocked',
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: unlockedCount / totalBadges,
                                  minHeight: 6,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. FILTER CHIPS
                  Row(
                    children: ['All', 'Unlocked', 'Locked'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: const Color(0xFF1E5E2F),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF1E293B),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF1E5E2F) : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 3. BADGES LIST CARDS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredBadges.length,
                    itemBuilder: (context, index) {
                      final badge = filteredBadges[index];
                      final bool isUnlocked = badge['isUnlocked'];
                      final Color iconColor = badge['color'];

                      return GestureDetector(
                        onTap: () => _showBadgeDialog(badge),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isUnlocked
                                  ? iconColor.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.05),
                              width: isUnlocked ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isUnlocked
                                    ? iconColor.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Badge Icon Circle
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? iconColor.withValues(alpha: 0.12)
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  badge['icon'] as IconData,
                                  size: 26,
                                  color: isUnlocked ? iconColor : Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          badge['title'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isUnlocked
                                                ? const Color(0xFF1E293B)
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        if (isUnlocked)
                                          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF1E5E2F)),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      badge['desc'],
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    if (!isUnlocked) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                value: badge['progress'] as double,
                                                minHeight: 5,
                                                backgroundColor: Colors.grey.shade200,
                                                valueColor: AlwaysStoppedAnimation<Color>(iconColor.withValues(alpha: 0.7)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            badge['currentProgressText'] ?? 'Locked',
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Status Indicator
                              Icon(
                                isUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                                color: isUnlocked ? const Color(0xFF1E5E2F) : Colors.grey.shade400,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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