import 'package:flutter/material.dart';
import '../core/constants.dart';

class LeaderboardsView extends StatelessWidget {
  const LeaderboardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topStudents = [
      {'rank': 1, 'name': 'Rein (You)', 'points': '2,850 XP', 'avatar': '👑'},
      {'rank': 2, 'name': 'Maria Santos', 'points': '2,620 XP', 'avatar': '🥈'},
      {'rank': 3, 'name': 'Juan Cruz', 'points': '2,410 XP', 'avatar': '🥉'},
      {'rank': 4, 'name': 'Angela Reyes', 'points': '1,980 XP', 'avatar': '⭐'},
      {'rank': 5, 'name': 'Mark Dizon', 'points': '1,750 XP', 'avatar': '⭐'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topStudents.length,
        itemBuilder: (context, index) {
          final student = topStudents[index];
          final isUser = student['rank'] == 1;

          return Card(
            color: isUser ? AppColors.spcbaGreen.withValues(alpha: 0.08) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isUser ? AppColors.spcbaGreen : Colors.grey.shade300,
              ),
            ),
            child: ListTile(
              leading: Text(
                '#${student['rank']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isUser ? AppColors.spcbaGreen : Colors.black87,
                ),
              ),
              title: Text(
                student['name'],
                style: TextStyle(
                  fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(student['points']),
              trailing: Text(student['avatar'], style: const TextStyle(fontSize: 22)),
            ),
          );
        },
      ),
    );
  }
}