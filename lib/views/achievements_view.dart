import 'package:flutter/material.dart';
import '../core/constants.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> badges = [
      {'title': '7-Day Streak', 'desc': 'Studied 7 days in a row', 'unlocked': true, 'icon': Icons.local_fire_department, 'color': Colors.orange},
      {'title': 'Quiz Master', 'desc': 'Scored 100% on 5 quizzes', 'unlocked': true, 'icon': Icons.psychology, 'color': Colors.purple},
      {'title': 'Night Owl', 'desc': 'Completed a review past 10 PM', 'unlocked': false, 'icon': Icons.bedtime, 'color': Colors.indigo},
      {'title': 'Upload Champ', 'desc': 'Uploaded 10 reviewer documents', 'unlocked': false, 'icon': Icons.cloud_upload, 'color': Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final bool unlocked = badge['unlocked'];

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: unlocked ? (badge['color'] as Color).withValues(alpha: 0.2) : Colors.grey.shade200,
                child: Icon(
                  badge['icon'],
                  color: unlocked ? badge['color'] : Colors.grey,
                ),
              ),
              title: Text(
                badge['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: unlocked ? Colors.black87 : Colors.grey,
                ),
              ),
              subtitle: Text(badge['desc']),
              trailing: Icon(
                unlocked ? Icons.check_circle : Icons.lock,
                color: unlocked ? AppColors.spcbaGreen : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}