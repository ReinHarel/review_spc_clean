import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final List<Map<String, dynamic>> _badges = [
    {
      'title': '7-Day Streak',
      'desc': 'Studied for 7 consecutive days without breaking streak.',
      'icon': Icons.local_fire_department_rounded,
      'color': Colors.orange,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 5, 2026',
    },
    {
      'title': 'Quiz Master',
      'desc': 'Scored a perfect 100% score on 5 different AI Quizzes.',
      'icon': Icons.psychology_rounded,
      'color': Colors.purple,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 8, 2026',
    },
    {
      'title': 'AI Whisperer',
      'desc': 'Generated 20 customized flashcards using AI Study Hub.',
      'icon': Icons.auto_awesome_rounded,
      'color': Colors.amber,
      'isUnlocked': true,
      'unlockedDate': 'Unlocked Aug 9, 2026',
    },
    {
      'title': 'Night Owl',
      'desc': 'Completed an intensive study review past 10:00 PM.',
      'icon': Icons.nights_stay_rounded,
      'color': Colors.indigo,
      'isUnlocked': false,
      'progressText': '3/5 Late Sessions',
    },
    {
      'title': 'Upload Champ',
      'desc': 'Uploaded and processed 10 reviewer documents.',
      'icon': Icons.cloud_upload_rounded,
      'color': Colors.teal,
      'isUnlocked': false,
      'progressText': '4/10 Files',
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
                    : (badge['progressText'] ?? 'Locked'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text('Student Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('XP Progress to Level 5', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            Text('1,240 / 2,000 XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 1240 / 2000,
                            minHeight: 10,
                            backgroundColor: Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('760 XP to Honor Scholar', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. STATS CARDS
                  Row(
                    children: [
                      _buildStatCard('Total XP', '1,240', Icons.stars_rounded, Colors.amber),
                      const SizedBox(width: 10),
                      _buildStatCard('Streak', '5 🔥', Icons.local_fire_department_rounded, Colors.orange),
                      const SizedBox(width: 10),
                      _buildStatCard('Mastered', '3 ⭐', Icons.military_tech_rounded, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. ACHIEVEMENTS & BADGES SECTION
                  const Text(
                    'Unlocked Badges & Achievements 🏆',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _badges.length,
                      itemBuilder: (context, index) {
                        final badge = _badges[index];
                        final bool isUnlocked = badge['isUnlocked'];
                        final Color color = badge['color'];

                        return GestureDetector(
                          onTap: () => _showBadgeDialog(badge),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isUnlocked ? color.withValues(alpha: 0.4) : Colors.grey.shade300,
                                width: isUnlocked ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isUnlocked ? color.withValues(alpha: 0.1) : Colors.transparent,
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
                                    color: isUnlocked ? color.withValues(alpha: 0.12) : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    badge['icon'] as IconData,
                                    size: 24,
                                    color: isUnlocked ? color : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  badge['title'],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked ? const Color(0xFF1E293B) : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. RANK LEVELS
                  const Text(
                    'Rank Levels',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildRankTile('Lv1 — Freshman Reviewer', false),
                        _buildRankTile('Lv2 — Dedicated Student', false),
                        _buildRankTile('Lv3 — Quiz Enthusiast', false),
                        _buildRankTile('Lv4 — Academic Warrior ← You', true),
                        _buildRankTile('Lv5 — Honor Scholar', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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
        color: isCurrent ? const Color(0xFFE8F5E9) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isCurrent ? const Color(0xFF1E5E2F) : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? const Color(0xFF1E293B) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}