import 'package:flutter/material.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedChipIndex = 0;

  final List<String> _chips = ['Overview', 'History', 'AI Insights', 'Calendar'];
  final List<IconData> _chipIcons = [
    Icons.bar_chart_rounded,
    Icons.history_rounded,
    Icons.auto_awesome_rounded,
    Icons.calendar_today_rounded,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. GREEN HEADER WITH CIRCULAR PROGRESS GAUGE
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1E5E2F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 24, top: 12),
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

            // 2. FILTER CHIPS (Overview, History, AI Insights, Calendar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_chips.length, (index) {
                  final isSelected = _selectedChipIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      avatar: Icon(
                        _chipIcons[index],
                        size: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      label: Text(_chips[index]),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E5E2F),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF1E5E2F) : Colors.grey.shade300,
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
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. AI STUDY RECOMMENDATION BANNER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade700,
                          radius: 18,
                          child: const Icon(Icons.psychology, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'AI Study Recommendation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Object-Oriented Programming has lower gains (+21%). Take a 5-min practice quiz to boost it!',
                                style: TextStyle(fontSize: 11, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Review', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. PRE-TEST VS POST-TEST STAT CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Pre-test',
                          '52%',
                          'Initial score',
                          Colors.red.shade50,
                          Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSummaryCard(
                          'Post-test',
                          '84%',
                          'Current avg',
                          Colors.green.shade50,
                          Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSummaryCard(
                          'Gained',
                          '+32%',
                          'Total growth',
                          Colors.orange.shade50,
                          Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 5. WEEKLY FOCUS TIME CHART
                  _buildWeeklyFocusChart(),

                  const SizedBox(height: 20),

                  // 6. PRE-TEST VS POST-TEST COMPARISON SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Pre-test vs Post-test Comparison',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'Growth',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildSubjectComparisonCard(
                    'Data Structures & Algorithms',
                    '+35%',
                    0.65,
                    0.88,
                    '65%',
                    '88%',
                  ),
                  _buildSubjectComparisonCard(
                    'Web Systems & Technologies',
                    '+36%',
                    0.57,
                    0.79,
                    '57%',
                    '79%',
                  ),
                  _buildSubjectComparisonCard(
                    'Object-Oriented Programming',
                    '+21%',
                    0.70,
                    0.85,
                    '70%',
                    '85%',
                    badgeLabel: 'Review Soon',
                  ),

                  const SizedBox(height: 20),

                  // 7. SUBJECT HOURS DISTRIBUTION
                  const Text(
                    'Subject Hours Distribution',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  _buildSubjectHoursCard(),

                  const SizedBox(height: 20),

                  // 8. THIS WEEK ACTIVITY SUMMARY
                  const Text(
                    'This week activity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  _buildThisWeekActivity(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Summary Cards (Pre-test, Post-test, Gained)
  Widget _buildSummaryCard(
    String title,
    String value,
    String subtitle,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withAlpha(50)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Weekly Focus Time Chart
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
              Text(
                'Weekly Focus Time ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text('⏱️', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Total: 18.5 hours studied this week',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final double heightFactor = hours[index] / maxHour;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${hours[index]}h',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5E2F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 18,
                    height: 100 * heightFactor,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5E2F),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Subject Comparison Card
  Widget _buildSubjectComparisonCard(
    String title,
    String growth,
    double preVal,
    double postVal,
    String preText,
    String postText, {
    String? badgeLabel,
  }) {
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              if (badgeLabel != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(fontSize: 10, color: Colors.orange.shade900),
                  ),
                ),
              ],
              Text(
                '📈 $growth',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(
                width: 60,
                child: Text('Pre-test', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: preVal,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                child: Text(
                  preText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(
                width: 60,
                child: Text('Post-test', style: TextStyle(fontSize: 11, color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: postVal,
                    minHeight: 6,
                    backgroundColor: Colors.green.shade50,
                    color: const Color(0xFF1E5E2F),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                child: Text(
                  postText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget: Subject Hours Distribution
  Widget _buildSubjectHoursCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
          child: LinearProgressIndicator(
            value: val,
            minHeight: 6,
            backgroundColor: Colors.grey.shade100,
            color: color,
          ),
        ),
      ],
    );
  }

  // Helper Widget: This Week Activity Summary
  Widget _buildThisWeekActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
}