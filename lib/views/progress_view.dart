import 'package:flutter/material.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedChipIndex = 0;

  final List<String> _chips = ['Overview', 'Game Stats', 'History', 'AI Insights'];
  final List<IconData> _chipIcons = [
    Icons.bar_chart_rounded,
    Icons.sports_esports_rounded,
    Icons.history_rounded,
    Icons.auto_awesome_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Analytics & Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        
      ),
      body: Column(
        children: [
          // 1. FILTER CHIPS HEADER (Full-bleed solid green, fixed visibility)
          Container(
            width: double.infinity,
            color: const Color(0xFF1E5E2F),
            padding: const EdgeInsets.only(bottom: 16, top: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  ...List.generate(_chips.length, (index) {
                    final isSelected = _selectedChipIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        showCheckmark: false,
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(
                          _chipIcons[index],
                          size: 16,
                          color: isSelected ? const Color(0xFF1E5E2F) : Colors.white,
                        ),
                        label: Text(_chips[index]),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                        selected: isSelected,
                        selectedColor: Colors.white,
                        backgroundColor: const Color(0xFF144120), // Dark background para readable ang white text
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF1E5E2F) : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.white : Colors.white30,
                          ),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChipIndex = index;
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),

          // 2. DYNAMIC CONTENT AREA
          Expanded(
            child: SingleChildScrollView(
              child: _buildSelectedTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Router function to switch views
  Widget _buildSelectedTabContent() {
    switch (_selectedChipIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildGameStatsTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildAiInsightsTab();
      default:
        return _buildOverviewTab();
    }
  }

  // ==========================================
  // TAB 1: OVERVIEW
  // ==========================================
  Widget _buildOverviewTab() {
    return Column(
      children: [
        // GREEN HEADER WITH CIRCULAR PROGRESS GAUGE
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF1E5E2F),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.29,
                      strokeWidth: 10,
                      backgroundColor: Colors.black26,
                      color: Colors.amber,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        '+29%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Improvement',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Average Improvement Across All Subjects',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRE-TEST VS POST-TEST STAT CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard('Pre-test', '52%', 'Initial score', Colors.red.shade50, Colors.red.shade400),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryCard('Post-test', '84%', 'Current avg', Colors.green.shade50, Colors.green.shade700),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSummaryCard('Gained', '+32%', 'Total growth', Colors.orange.shade50, Colors.orange.shade700),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // WEEKLY FOCUS TIME CHART
              _buildWeeklyFocusChart(),

              const SizedBox(height: 20),

              // PRE-TEST VS POST-TEST COMPARISON SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Pre-test vs Post-test Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Growth', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),

              _buildSubjectComparisonCard('Data Structures & Algorithms', '+35%', 0.65, 0.88, '65%', '88%'),
              _buildSubjectComparisonCard('Web Systems & Technologies', '+36%', 0.57, 0.79, '57%', '79%'),
              _buildSubjectComparisonCard('Object-Oriented Programming', '+21%', 0.70, 0.85, '70%', '85%', badgeLabel: 'Review Soon'),

              const SizedBox(height: 20),

              // SUBJECT HOURS DISTRIBUTION
              const Text('Subject Hours Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              _buildSubjectHoursCard(),

              const SizedBox(height: 20),

              // THIS WEEK ACTIVITY SUMMARY
              const Text('This week activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              _buildThisWeekActivity(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: GAME STATS
  // ==========================================
  Widget _buildGameStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: const [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: 0.82,
                        strokeWidth: 8,
                        backgroundColor: Color(0xFFE0E0E0),
                        color: Color(0xFF1E5E2F),
                      ),
                    ),
                    Text('82%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Overall Game Accuracy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Based on 350+ questions answered across all gamified modules.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildMetricTile('⚡ Avg Answer Speed', '8.4s', 'Per question', Colors.blue.shade50, Colors.blue.shade800)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricTile('🔥 Current Streak', '5 Days', 'Keep it up!', Colors.orange.shade50, Colors.orange.shade800)),
            ],
          ),

          const SizedBox(height: 20),

          const Text('Game Mode Mastery Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),

          _buildGameModeRow('Swipe True/False', '92% Accuracy', 0.92, '⚡ Lightning Fast', Colors.green),
          _buildGameModeRow('Flashcards', '88% Accuracy', 0.88, '🎯 High Mastery', Colors.blue),
          _buildGameModeRow('Multiple Choice', '78% Accuracy', 0.78, '👍 Solid', Colors.teal),
          _buildGameModeRow('Active Recall', '70% Accuracy', 0.70, '⚠️ Needs Practice', Colors.orange),
          _buildGameModeRow('Sequential Drag & Drop', '62% Accuracy', 0.62, '🛑 Focus Area', Colors.red),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: HISTORY
  // ==========================================
  Widget _buildHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today — May 17', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 10),

          _buildHistoryItem(
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            title: 'Data Structures quiz',
            subtitle: 'Score 84% • Hard mode • +40 XP',
            badgeText: 'Synced',
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),
          _buildHistoryItem(
            icon: Icons.psychology_rounded,
            iconColor: Colors.purple,
            title: 'AI Tutor session',
            subtitle: 'Data Structures • 5 questions asked',
            badgeText: 'View',
            badgeColor: Colors.purple.shade100,
            badgeTextColor: Colors.purple.shade900,
          ),
          _buildHistoryItem(
            icon: Icons.style_rounded,
            iconColor: Colors.amber.shade700,
            title: 'Flashcard session',
            subtitle: '20 cards • 14 Know it • 6 Review again',
            badgeText: 'Done',
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),

          const SizedBox(height: 20),
          const Text('Yesterday — May 16', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 10),

          _buildHistoryItem(
            icon: Icons.star_rounded,
            iconColor: Colors.orange,
            title: 'Badge earned',
            subtitle: 'Quiz Master • Performance badge',
            badgeText: 'New',
            badgeColor: Colors.orange.shade100,
            badgeTextColor: Colors.orange.shade900,
          ),
          _buildHistoryItem(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.deepOrange,
            title: '5-day streak achieved',
            subtitle: 'Keep going • +100 XP bonus',
            badgeText: '+100 XP',
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),
          _buildHistoryItem(
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            title: 'Networking quiz',
            subtitle: 'Score 70% • Medium • +20 XP',
            badgeText: 'Synced',
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),
          _buildHistoryItem(
            icon: Icons.upload_file_rounded,
            iconColor: Colors.blue,
            title: 'File uploaded',
            subtitle: 'IT301-DataStructures.pdf • 25 questions generated',
            badgeText: 'Done',
            badgeColor: Colors.green.shade100,
            badgeTextColor: Colors.green.shade900,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 4: AI INSIGHTS
  // ==========================================
  Widget _buildAiInsightsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Color(0xFF1565C0)),
                    SizedBox(width: 8),
                    Text(
                      'AI Performance Coach',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1565C0)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Based on your recent game stats, your memory retention is highest with Swipe True/False (92%). However, Sequential Drag & Drop shows lower accuracy (62%).',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Start Recommended 5-Min Drag & Drop Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Focus Area Recommendations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          _buildInsightCard('Peak Focus Window', 'You complete questions 15% faster between 9:00 AM - 11:00 AM.', Icons.access_time_filled),
          _buildInsightCard('Spaced Repetition Alert', 'Philippine History was reviewed 5 days ago. Review today to avoid forgetting curve.', Icons.replay),
        ],
      ),
    );
  }

  // ==========================================
  // REUSABLE HELPER WIDGETS
  // ==========================================

  Widget _buildSummaryCard(String title, String value, String subtitle, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _buildWeeklyFocusChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final hours = [3.5, 2.0, 4.2, 2.8, 3.0, 1.5, 1.0];
    const maxHour = 5.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Weekly Focus Time ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('⏱️', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Total: 18.5 hours studied this week', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final double heightFactor = hours[index] / maxHour;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${hours[index]}h', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
                    const SizedBox(height: 4),
                    Container(
                      width: 16,
                      height: 80 * heightFactor,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5E2F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(days[index], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectComparisonCard(String title, String growth, double preVal, double postVal, String preText, String postText, {String? badgeLabel}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
              if (badgeLabel != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(10)),
                  child: Text(badgeLabel, style: TextStyle(fontSize: 10, color: Colors.orange.shade900)),
                ),
              ],
              Text('📈 $growth', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 60, child: Text('Pre-test', style: TextStyle(fontSize: 11, color: Colors.grey))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: preVal, minHeight: 6, backgroundColor: Colors.grey.shade200, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 32, child: Text(preText, textAlign: TextAlign.end, style: const TextStyle(fontSize: 11, color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 60, child: Text('Post-test', style: TextStyle(fontSize: 11, color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: postVal, minHeight: 6, backgroundColor: Colors.green.shade50, color: const Color(0xFF1E5E2F)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 32, child: Text(postText, textAlign: TextAlign.end, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectHoursCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildHourRow('Biology 101', '6.5 hrs studied', 0.65, Colors.green),
          const SizedBox(height: 12),
          _buildHourRow('Computer Prog 2', '8.0 hrs studied', 0.85, Colors.blue),
          const SizedBox(height: 12),
          _buildHourRow('Philippine History', '4.0 hrs studied', 0.45, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildHourRow(String title, String hrs, double val, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(hrs, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: val, minHeight: 6, backgroundColor: Colors.grey.shade100, color: color),
        ),
      ],
    );
  }

  Widget _buildThisWeekActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActivityStat(Icons.fact_check_outlined, '14', 'Quizzes'),
          _buildActivityStat(Icons.pie_chart_outline, '78%', 'Avg Score'),
          _buildActivityStat(Icons.stars_outlined, '420', 'XP Earned'),
          _buildActivityStat(Icons.local_fire_department_outlined, '5d', 'Streak'),
        ],
      ),
    );
  }

  Widget _buildActivityStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1E5E2F), size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, String subtitle, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildGameModeRow(String title, String acc, double val, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: val, minHeight: 6, backgroundColor: Colors.grey.shade200, color: color),
                ),
              ),
              const SizedBox(width: 10),
              Text(acc, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
            child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.green.shade50, child: Icon(icon, color: const Color(0xFF1E5E2F))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}