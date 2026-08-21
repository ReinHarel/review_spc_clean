import 'package:flutter/material.dart';

import '../models/game_progress.dart';
import '../theme_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  GameProgressStore get _store => GameProgressStore.instance;

  List<BadgeData> get _featuredBadges => _store.progress.unlockedBadges;

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
                color: isUnlocked
                    ? badge.color.withValues(alpha: 0.15)
                    : Colors.grey.shade200,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
                isUnlocked
                    ? badge.unlockedDate
                    : (badge.currentProgressText.isEmpty ? 'Locked' : badge.currentProgressText),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text('Student Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          final GameProgress progress = _store.progress;
          return SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER CARD WITH USER INFO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5E2F),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.amberAccent,
                          child: Text('JD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                        const SizedBox(height: 12),
                        const Text('Juan Dela Cruz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text('BSIT - 3rd Year • Section 501', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield_rounded, size: 16, color: Colors.black87),
                              SizedBox(width: 6),
                              Text('Academic Warrior • Level 4', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. XP PROGRESS BAR
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'XP Progress to Level ${progress.level + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${progress.xp} / ${progress.xpToNext} XP',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E5E2F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress.xpProgress,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${progress.xpToNext - progress.xp} XP to Honor Scholar',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. STATS CARDS
                  Row(
                    children: [
                      _buildStatCard('Total XP', '${progress.xp}', Icons.stars_rounded, Colors.amber),
                      const SizedBox(width: 10),
                      _buildStatCard('Streak', '5 🔥', Icons.local_fire_department_rounded, Colors.orange),
                      const SizedBox(width: 10),
                      _buildStatCard('Mastered', '${progress.unlockedCount} ⭐', Icons.military_tech_rounded, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. FEATURED BADGES SHOWCASE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.emoji_events_rounded, size: 20, color: Color(0xFF1E5E2F)),
                            const SizedBox(width: 8),
                            Text(
                              'Featured Badges',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Lv${progress.level} • ${progress.xp} XP',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${progress.unlockedCount} of ${progress.totalBadges} badges unlocked',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_featuredBadges.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Complete quizzes to earn your first badge!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featuredBadges.length,
                              itemBuilder: (context, index) {
                                final badge = _featuredBadges[index];
                                final Color color = badge.color;

                                return GestureDetector(
                                  onTap: () => _showBadgeDialog(badge),
                                  child: Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.12),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(badge.icon, size: 22, color: color),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          badge.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. RANK LEVELS
                  Text(
                    'Rank Levels',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 320),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildRankTile('Lv1 — Freshman Reviewer', false),
                            _buildRankTile('Lv2 — Dedicated Student', false),
                            _buildRankTile('Lv3 — Quiz Enthusiast', false),
                            _buildRankTile('Lv4 — Academic Warrior ← You', true),
                            _buildRankTile('Lv5 — Honor Scholar', false),
                            _buildRankTile('Lv6 — Master Strategist', false),
                            _buildRankTile('Lv7 — Knowledge Titan', false),
                            _buildRankTile('Lv8 — Dean\'s Lister', false),
                            _buildRankTile('Lv9 — Grandmaster Reviewer', false),
                            _buildRankTile('Lv10 — Valedictorian Elite', false),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. ACCOUNT SETTINGS
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildThemeTile(),
_buildSettingsTile(Icons.edit_rounded, 'Edit Profile', 'Update your personal information', const Color(0xFF60A5FA)),
                  _buildSettingsTile(Icons.notifications_rounded, 'Notifications', 'Manage your notification preferences', const Color(0xFFFBBF24)),
                  _buildSettingsTile(Icons.security_rounded, 'Security', 'Change password and privacy settings', const Color(0xFFF87171)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 7. LOG OUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            content: const Text('Are you sure you want to log out of your account?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Log Out', style: TextStyle(color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E5E2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
      ),
    );
  }


  Widget _buildThemeTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.mode,
        builder: (context, mode, _) {
          final bool isDark = mode == ThemeMode.dark;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2ECC71).withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 20,
                  color: isDark
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFF1E5E2F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDark ? 'Using dark theme' : 'Switch to a dark theme',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                activeTrackColor: const Color(0xFF2ECC71),
                onChanged: ThemeController.setDark,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, Color accent) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            content: Text(
              '$title feature coming soon.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? accent.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? accent : const Color(0xFF1E5E2F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankTile(String title, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isCurrent
                ? const Color(0xFF1E5E2F)
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}