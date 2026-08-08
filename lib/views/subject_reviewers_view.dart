import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'subject_detail_view.dart';

class SubjectReviewersView extends StatelessWidget {
  const SubjectReviewersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample Subject List Data
    final List<Map<String, dynamic>> subjects = [
      {
        'title': 'Data Structures & Algorithms',
        'code': 'IT 101',
        'topics': '12 Topics',
        'icon': Icons.account_tree_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Web Systems & Technologies',
        'code': 'IT 102',
        'topics': '8 Topics',
        'icon': Icons.language_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Object-Oriented Programming',
        'code': 'IT 103',
        'topics': '10 Topics',
        'icon': Icons.code_rounded,
        'color': Colors.purple,
      },
      {
        'title': 'Database Management Systems',
        'code': 'IT 104',
        'topics': '15 Topics',
        'icon': Icons.storage_rounded,
        'color': Colors.teal,
      },
      {
        'title': 'Information Assurance & Security',
        'code': 'IT 105',
        'topics': '7 Topics',
        'icon': Icons.security_rounded,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Reviewers', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (subject['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject['icon'] as IconData, color: subject['color'] as Color),
              ),
              title: Text(
                subject['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${subject['code']} • ${subject['topics']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SubjectDetailView(
        subjectTitle: subject['title'] as String,
        subjectCode: subject['code'] as String,
      ),
    ),
  );
},
            ),
          );
        },
      ),
    );
  }
}