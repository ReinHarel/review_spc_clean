import 'package:flutter/material.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Overview', 'History', 'AI Tutor', 'Calendar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics & Progress',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Green Banner with Donut Ring Progress
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E5E2F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    // Donut Ring Chart Centerpiece
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: CircularProgressIndicator(
                              value: 0.29, // +29% Improvement
                              strokeWidth: 12,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Average Improvement Across All Subjects',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Main Analytics Content Body
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Category Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tabs.length, (index) {
                            final isSelected = _selectedTabIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(_tabs[index]),
                                selected: isSelected,
                                selectedColor: const Color(0xFF1E5E2F),
                                backgroundColor: const Color(0xFFE5EDE4),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedTabIndex = index;
                                    });
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 1: Pre-test vs Post-test Metrics
                      const Text(
                        'Pre-test vs Post-test',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildSummaryMetricCard('Pre-test', '52%', 'Before app', const Color(0xFFFFEBEE), Colors.red.shade700),
                          const SizedBox(width: 10),
                          _buildSummaryMetricCard('Post-test', '84%', 'After app', const Color(0xFFE8F5E9), const Color(0xFF1E5E2F)),
                          const SizedBox(width: 10),
                          _buildSummaryMetricCard('Gained', '+32%', 'Improvement', const Color(0xFFE8F5E9), const Color(0xFF1E5E2F)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section 2: Pre-test vs Post-test Comparison Bars per Subject
                      const Text(
                        'Pre-test vs Post-test Comparison',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSubjectComparisonCard(
                        'Data Structures & Algorithms',
                        preTestScore: 0.65,
                        postTestScore: 0.88,
                        preTestText: '65%',
                        postTestText: '88%',
                        gainText: '+35%',
                      ),
                      _buildSubjectComparisonCard(
                        'Web Systems & Technologies',
                        preTestScore: 0.57,
                        postTestScore: 0.79,
                        preTestText: '57%',
                        postTestText: '79%',
                        gainText: '+36%',
                      ),
                      _buildSubjectComparisonCard(
                        'Object-Oriented Programming',
                        preTestScore: 0.70,
                        postTestScore: 0.85,
                        preTestText: '70%',
                        postTestText: '85%',
                        gainText: '+21%',
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Weekly Activity Metrics
                      const Text(
                        'This week',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildWeeklyStatBox('Quizzes', '14'),
                          const SizedBox(width: 8),
                          _buildWeeklyStatBox('Avg score', '78%'),
                          const SizedBox(width: 8),
                          _buildWeeklyStatBox('XP earned', '420'),
                          const SizedBox(width: 8),
                          _buildWeeklyStatBox('Streak', '5d'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary Cards (Pre-test / Post-test / Gain)
  Widget _buildSummaryMetricCard(String title, String value, String subtitle, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // Subject Progress Bars Card
  Widget _buildSubjectComparisonCard(
    String title, {
    required double preTestScore,
    required double postTestScore,
    required String preTestText,
    required String postTestText,
    required String gainText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECE5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.show_chart_rounded, size: 16, color: Color(0xFF1E5E2F)),
                  const SizedBox(width: 4),
                  Text(
                    gainText,
                    style: const TextStyle(
                      color: Color(0xFF1E5E2F),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pre-test Progress Bar
          Row(
            children: [
              const SizedBox(
                width: 65,
                child: Text('Pre-test', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: preTestScore,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.grey.shade500,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 32,
                child: Text(
                  preTestText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Post-test Progress Bar
          Row(
            children: [
              const SizedBox(
                width: 65,
                child: Text(
                  'Post-test',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: postTestScore,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF1E5E2F),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 32,
                child: Text(
                  postTestText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Weekly Stat Boxes
  Widget _buildWeeklyStatBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECE5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}