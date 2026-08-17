import 'package:flutter/material.dart';

import '../models/game_progress.dart';

class AchievementsView extends StatefulWidget {
  const AchievementsView({super.key});

  @override
  State<AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<AchievementsView> {
  String _selectedFilter = 'All';

  List<BadgeData> get _badges => GameProgressStore.instance.progress.badges;

  List<BadgeData> get _filteredBadges => _badges.where((badge) {
        if (_selectedFilter == 'Unlocked') return badge.isUnlocked;
        if (_selectedFilter == 'Locked') return !badge.isUnlocked;
        return true;
      }).toList();

  void _showBadgeDialog(BadgeData badge) {
    final bool isUnlocked = badge.isUnlocked;
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
                color: isUnlocked ? badge.color.withValues(alpha: 0.15) : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                size: 52,
                color: isUnlocked ? badge.color : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            Text(
              badge.desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked ? Colors.green.shade300 : Colors.grey.shade300,
                ),
              ),
              child: Text(
                isUnlocked ? badge.unlockedDate : (badge.currentProgressText.isEmpty ? 'Locked' : badge.currentProgressText),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.green.shade700 : Colors.grey.shade700,
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

  Widget _buildXpBanner(GameProgress progress) {
    final unlockedCount = progress.unlockedCount;
    final totalBadges = progress.totalBadges;

    return Container(
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
                  value: progress.xpProgress,
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
                    Text(
                      '${progress.levelTitle} 🎓',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${progress.xp} XP',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
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
                    value: totalBadges == 0 ? 0 : unlockedCount / totalBadges,
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListenableBuilder(
        listenable: GameProgressStore.instance,
        builder: (context, _) {
          final progress = GameProgressStore.instance.progress;
          final filteredBadges = _filteredBadges;

          return CustomScrollView(
            slivers: [
              // 1. PINNED LEVEL & XP BANNER (stays visible while scrolling)
              SliverPersistentHeader(
                pinned: true,
                delegate: _XpBannerSliverDelegate(
                  extent: 150,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 850),
                        child: _buildXpBanner(progress),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. FILTER CHIPS (pinned below header)
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          children: ['All', 'Unlocked', 'Locked'].map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(filter),
                                visualDensity: VisualDensity.compact,
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
                      ),
                    ),
                  ),
                ),
              ),

              // 3. BADGE CARDS (lazy-loaded SliverList)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList.builder(
                  itemCount: filteredBadges.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 850),
                        child: _buildBadgeCard(filteredBadges[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadgeCard(BadgeData badge) {
    final bool isUnlocked = badge.isUnlocked;
    final Color iconColor = badge.color;

    return GestureDetector(
      onTap: () => _showBadgeDialog(badge),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUnlocked ? iconColor.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
            width: isUnlocked ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked ? iconColor.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02),
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
                color: isUnlocked ? iconColor.withValues(alpha: 0.12) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
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
                        badge.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? const Color(0xFF1E293B) : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isUnlocked)
                        const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF1E5E2F)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    badge.desc,
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
                              value: badge.progress,
                              minHeight: 5,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(iconColor.withValues(alpha: 0.7)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          badge.currentProgressText.isEmpty ? 'Locked' : badge.currentProgressText,
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
  }
}

class _XpBannerSliverDelegate extends SliverPersistentHeaderDelegate {
  _XpBannerSliverDelegate({required this.child, required this.extent});

  final Widget child;
  final double extent;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _XpBannerSliverDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}