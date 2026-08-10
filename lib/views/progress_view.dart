import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text('Study Analytics & Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                  // 1. WEEKLY FOCUS SUMMARY CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weekly Focus Time ⏱️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(height: 4),
                        Text('Total: 18.5 hours studied this week', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        const SizedBox(height: 20),

                        // Simple Bar Visual representation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar('Mon', '3.5h', 0.8),
                            _buildBar('Tue', '2.0h', 0.5),
                            _buildBar('Wed', '4.2h', 0.9),
                            _buildBar('Thu', '2.8h', 0.6),
                            _buildBar('Fri', '3.0h', 0.7),
                            _buildBar('Sat', '1.5h', 0.4),
                            _buildBar('Sun', '1.0h', 0.3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. SUBJECT PERFORMANCE BREAKDOWN
                  const Text('Subject Hours Distribution', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 10),
                  _buildSubjectProgressCard('Biology 101', '6.5 hrs studied', 0.8, Colors.green),
                  _buildSubjectProgressCard('Computer Prog 2', '8.0 hrs studied', 0.95, Colors.blue),
                  _buildSubjectProgressCard('Philippine History', '4.0 hrs studied', 0.5, Colors.orange),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(String day, String label, double heightFactor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
        const SizedBox(height: 6),
        Container(
          height: 120 * heightFactor,
          width: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF1E5E2F),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSubjectProgressCard(String title, String subtitle, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}