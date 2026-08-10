import 'package:flutter/material.dart';

import 'quiz_hub_view.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedTabIndex = 0;

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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 20),
            tooltip: 'Export Progress',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting report as PDF...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌟 1. PREMIUM HERO HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E5E2F), Color(0xFF0F3819)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: 0.84,
                          strokeWidth: 9,
                          backgroundColor: Colors.white12,
                          color: const Color(0xFFFFC107), // Gold accent
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '+29%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Improvement',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Average Improvement Across All Subjects',
                    style: TextStyle(
                      color: Color(0xFFD0E3D3),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // 📍 MAIN CONTENT CONTAINER
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎛️ 2. FILTER TABS (SEGMENT CONTROL)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTabPill('Overview', 0, Icons.insert_chart_outlined_rounded),
                            _buildTabPill('History', 1, Icons.history_rounded),
                            _buildTabPill('AI Insights', 2, Icons.auto_awesome_rounded),
                            _buildTabPill('Calendar', 3, Icons.calendar_today_rounded),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 💡 3. AI SMART RECOMMENDATION CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF90CAF9)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1976D2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 22),
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
                                      fontSize: 13,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Object-Oriented Programming has lower gains (+21%). Take a 5-min practice quiz to boost it!',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF1565C0)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHubView()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Review', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 📊 4. STAT SUMMARY CARDS (PRE VS POST)
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Pre-test',
                              value: '52%',
                              subtitle: 'Initial score',
                              bgColor: const Color(0xFFFFF0F0),
                              valueColor: const Color(0xFFD32F2F),
                              borderColor: const Color(0xFFFFCDD2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Post-test',
                              value: '84%',
                              subtitle: 'Current avg',
                              bgColor: const Color(0xFFE8F5E9),
                              valueColor: const Color(0xFF2E7D32),
                              borderColor: const Color(0xFFC8E6C9),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Gained',
                              value: '+32%',
                              subtitle: 'Total growth',
                              bgColor: const Color(0xFFFFF8E1),
                              valueColor: const Color(0xFFF57F17),
                              borderColor: const Color(0xFFFFECB3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 📈 5. SUBJECT COMPARISON BARS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Pre-test vs Post-test Comparison',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Growth',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildSubjectProgressCard(
                        subjectName: 'Data Structures & Algorithms',
                        preScore: 65,
                        postScore: 88,
                        growth: '+35%',
                        isTopPerformer: true,
                      ),
                      _buildSubjectProgressCard(
                        subjectName: 'Web Systems & Technologies',
                        preScore: 57,
                        postScore: 79,
                        growth: '+36%',
                      ),
                      _buildSubjectProgressCard(
                        subjectName: 'Object-Oriented Programming',
                        preScore: 70,
                        postScore: 85,
                        growth: '+21%',
                        needsFocus: true,
                      ),

                      const SizedBox(height: 24),

                      // 📅 6. WEEKLY STATS ROW
                      const Text(
                        'This week activity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat('Quizzes', '14', Icons.assignment_turned_in_rounded),
                            _buildMiniStat('Avg Score', '78%', Icons.pie_chart_outline_rounded),
                            _buildMiniStat('XP Earned', '420', Icons.stars_rounded),
                            _buildMiniStat('Streak', '5d', Icons.local_fire_department_rounded),
                          ],
                        ),
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

  // --- WIDGET HELPER METHODS ---

  Widget _buildTabPill(String label, int index, IconData icon) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E5E2F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E5E2F) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color bgColor,
    required Color valueColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: valueColor.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressCard({
    required String subjectName,
    required int preScore,
    required int postScore,
    required String growth,
    bool isTopPerformer = false,
    bool needsFocus = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (needsFocus) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          'Review Soon',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '📈 $growth',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Bar for Pre-test
          Row(
            children: [
              const SizedBox(width: 55, child: Text('Pre-test', style: TextStyle(fontSize: 10, color: Colors.grey))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: preScore / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$preScore%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),

          // Bar for Post-test
          Row(
            children: [
              const SizedBox(width: 55, child: Text('Post-test', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: postScore / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE8F5E9),
                    color: const Color(0xFF1E5E2F),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$postScore%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E5E2F)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}