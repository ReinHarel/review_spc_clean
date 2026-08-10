import 'package:flutter/material.dart';

class LeaderboardsView extends StatefulWidget {
  const LeaderboardsView({super.key});

  @override
  State<LeaderboardsView> createState() => _LeaderboardsViewState();
}

class _LeaderboardsViewState extends State<LeaderboardsView> {
  String _selectedTimeframe = 'Weekly';
  String _selectedCourse = 'BSIT';
  String _selectedYearSec = '3-A';

  final List<Map<String, dynamic>> _leaderboardData = [
    {
      'rank': 1,
      'rankChange': 0, // 0 = no change, >0 = up, <0 = down
      'name': 'Rein (You)',
      'xp': 2850,
      'course': 'BSIT 3-A',
      'streak': '7d 🔥',
      'avatarColor': Colors.amber,
      'isUser': true,
    },
    {
      'rank': 2,
      'rankChange': 1,
      'name': 'Maria Santos',
      'xp': 2620,
      'course': 'BSIT 3-A',
      'streak': '5d 🔥',
      'avatarColor': Colors.blueGrey,
      'isUser': false,
    },
    {
      'rank': 3,
      'rankChange': -1,
      'name': 'Juan Cruz',
      'xp': 2410,
      'course': 'BSIT 3-B',
      'streak': '4d 🔥',
      'avatarColor': Colors.deepOrange,
      'isUser': false,
    },
    {
      'rank': 4,
      'rankChange': 2,
      'name': 'Angela Reyes',
      'xp': 1980,
      'course': 'BSCS 3-A',
      'streak': '3d 🔥',
      'avatarColor': Colors.purple,
      'isUser': false,
    },
    {
      'rank': 5,
      'rankChange': -1,
      'name': 'Mark Dizon',
      'xp': 1750,
      'course': 'BSIT 3-A',
      'streak': '2d 🔥',
      'avatarColor': Colors.teal,
      'isUser': false,
    },
    {
      'rank': 6,
      'rankChange': 0,
      'name': 'Bea Gonzales',
      'xp': 1600,
      'course': 'BSIS 3-A',
      'streak': '1d 🔥',
      'avatarColor': Colors.indigo,
      'isUser': false,
    },
  ];

  void _challengeStudent(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sports_esports_rounded, color: Color(0xFF1E5E2F)),
            SizedBox(width: 8),
            Text('Quiz Duel! ⚔️', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Do you want to challenge $name to a 5-Question Quick Duel for +50 XP?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5E2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('⚔️ Challenge sent to $name! Waiting for response...'),
                  backgroundColor: const Color(0xFF1E5E2F),
                ),
              );
            },
            child: const Text('Send Challenge'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top3 = _leaderboardData.take(3).toList();
    final remainingRanks = _leaderboardData.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboards',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. SLEEK & COMPACT HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5E2F),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // LEAGUE TIER - SLEEK COMPACT BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'GOLD LEAGUE 🏆',
                                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                                Text(
                                  'Top 3 Promote',
                                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const LinearProgressIndicator(
                                value: 0.82,
                                minHeight: 5,
                                backgroundColor: Colors.white12,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // TIMEFRAME SWITCHER
                Container(
                  height: 38,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: ['Weekly', 'Monthly', 'All Time'].map((time) {
                      final isSelected = _selectedTimeframe == time;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeframe = time),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? const Color(0xFF1E5E2F) : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),

                // DROPDOWNS ROW
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.school_rounded,
                        value: _selectedCourse,
                        items: ['BSIT', 'BSCS', 'BSIS', 'All Courses'],
                        onChanged: (val) => setState(() => _selectedCourse = val!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.groups_rounded,
                        value: _selectedYearSec,
                        items: ['3-A', '3-B', '3-C', 'All Sections'],
                        onChanged: (val) => setState(() => _selectedYearSec = val!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. MAIN SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
              child: Column(
                children: [
                  // PODIUM SECTION (TOP 3)
                  if (top3.length >= 3) _buildPodiumSection(top3),
                  const SizedBox(height: 20),

                  // RANKINGS LIST (RANK 4+)
                  ...remainingRanks.map((student) => _buildRankCard(student)),
                ],
              ),
            ),
          ),

          // 3. YOUR STICKY RANK CARD AT THE BOTTOM
          _buildUserStickyCard(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E5E2F),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumSection(List<Map<String, dynamic>> top3) {
    final rank1 = top3[0];
    final rank2 = top3[1];
    final rank3 = top3[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // RANK 2 (SILVER)
        Expanded(child: _buildPodiumTile(rank2, 2, const Color(0xFFC0C0C0), 110)),
        const SizedBox(width: 8),
        // RANK 1 (GOLD)
        Expanded(child: _buildPodiumTile(rank1, 1, const Color(0xFFFFD700), 140)),
        const SizedBox(width: 8),
        // RANK 3 (BRONZE)
        Expanded(child: _buildPodiumTile(rank3, 3, const Color(0xFFCD7F32), 95)),
      ],
    );
  }

  Widget _buildPodiumTile(Map<String, dynamic> student, int rank, Color crownColor, double height) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 28 : 22,
              backgroundColor: student['avatarColor'],
              child: Text(
                student['name'][0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Positioned(
              top: -16,
              child: Icon(Icons.workspace_premium_rounded, color: crownColor, size: rank == 1 ? 28 : 22),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          student['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${student['xp']} XP',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E5E2F)),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [crownColor.withValues(alpha: 0.8), crownColor.withValues(alpha: 0.3)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankCard(Map<String, dynamic> student) {
    final isUser = student['isUser'] == true;
    final rankChange = student['rankChange'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFFDCFCE7) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser ? const Color(0xFF1E5E2F) : Colors.grey.shade200,
          width: isUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // RANK NUMBER & JUMP INDICATOR
          SizedBox(
            width: 36,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#${student['rank']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isUser ? const Color(0xFF1E5E2F) : Colors.grey.shade800,
                  ),
                ),
                if (rankChange > 0)
                  Text('▲$rankChange', style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold))
                else if (rankChange < 0)
                  Text('▼${rankChange.abs()}', style: const TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold))
                else
                  const Text('—', style: TextStyle(color: Colors.grey, fontSize: 9)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: student['avatarColor'],
            child: Text(
              student['name'][0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  '${student['course']} • ${student['streak']}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${student['xp']} XP',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E5E2F)),
          ),

          // CHALLENGE DUEL BUTTON (Only for other students)
          if (!isUser) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _challengeStudent(student['name']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E5E2F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text('⚔️', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserStickyCard() {
    final user = _leaderboardData.firstWhere((element) => element['isUser'] == true);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E5E2F),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.amber,
            child: Icon(Icons.star_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Rank: #${user['rank']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Top 1%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${user['course']} • Keep studying to hold #1 spot!',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '${user['xp']} XP',
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}