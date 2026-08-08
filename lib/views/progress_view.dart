import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'dashboard_view.dart';
import 'leaderboards_view.dart';
import 'ai_tutor_view.dart';
import 'study_planner_view.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedTopTab = 0; // 0: Overview, 1: History, 2: AI Tutor, 3: Calendar
  int _selectedBottomNav = 1; // 1 is Active for Progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My progress', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('BSIT - Regular Status', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Top Segmented Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('Overview', 0),
                  const SizedBox(width: 8),
                  _buildTabButton('History', 1),
                  const SizedBox(width: 8),
                  _buildTabButton('AI Tutor', 2),
                  const SizedBox(width: 8),
                  _buildTabButton('Calendar', 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),

          // Dynamic Active Content based on Top Tab Selection
          Expanded(
            child: _buildActiveTopTabContent(),
          ),
        ],
      ),

      // Working Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNav,
        selectedItemColor: AppColors.spcbaGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == _selectedBottomNav) return;

          if (index == 0) {
            // Home / Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardView(userName: 'Rein', studentStatus: 'Regular'),
              ),
            );
          } else if (index == 2) {
            // Leaderboards (Trophy)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaderboardsView()),
            );
          } else if (index == 3) {
            // Profile (Placeholder alert)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening Profile Settings...')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTopTab == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.spcbaGreen : Colors.grey.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {
        setState(() {
          _selectedTopTab = index;
        });
      },
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildActiveTopTabContent() {
    switch (_selectedTopTab) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildHistoryContent();
      case 2:
        return const AiTutorView(); // Embedded AI Tutor view
      case 3:
        return const StudyPlannerView(); // Embedded Calendar / Study Planner view
      default:
        return _buildOverviewContent();
    }
  }

  // 0. Overview Tab Content
  Widget _buildOverviewContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Pre-test vs post-test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard('Pre-test', '52%', 'Before app', Colors.red.shade50, Colors.red),
            const SizedBox(width: 8),
            _buildStatCard('Post-test', '84%', 'After app', Colors.green.shade50, Colors.green),
            const SizedBox(width: 8),
            _buildStatCard('Gained', '+32%', 'Improvement', Colors.lightGreen.shade50, AppColors.spcbaGreen),
          ],
        ),
        const SizedBox(height: 24),
        const Text('This week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMiniStat('Quizzes', '14'),
            const SizedBox(width: 8),
            _buildMiniStat('Avg score', '78%'),
            const SizedBox(width: 8),
            _buildMiniStat('XP earned', '420'),
            const SizedBox(width: 8),
            _buildMiniStat('Streak', '5d'),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Subject mastery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildMasteryBar('Data Structures', 0.92, '92% Mastered', Colors.green),
        const SizedBox(height: 12),
        _buildMasteryBar('Networking', 0.75, '75% Proficient', Colors.lightGreen),
        const SizedBox(height: 12),
        _buildMasteryBar('Algorithms', 0.45, '45% Developing', Colors.orange),
      ],
    );
  }

  // 1. History Tab Content
  Widget _buildHistoryContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Quiz History & Activity Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Data Structures - Quiz 3'),
          subtitle: Text('Score: 9/10 • Yesterday'),
          trailing: Text('+50 XP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Networking Fundamentals'),
          subtitle: Text('Score: 8/10 • 3 days ago'),
          trailing: Text('+40 XP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.cancel, color: Colors.red),
          title: Text('Algorithms Pre-test'),
          subtitle: Text('Score: 4/10 • 5 days ago'),
          trailing: Text('+10 XP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String sub, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryBar(String title, double progress, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}