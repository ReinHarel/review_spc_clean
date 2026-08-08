import 'package:flutter/material.dart';
import '../core/constants.dart';

class SubjectDetailView extends StatelessWidget {
  final String subjectTitle;
  final String subjectCode;

  const SubjectDetailView({
    super.key,
    required this.subjectTitle,
    required this.subjectCode,
  });

  @override
  Widget build(BuildContext context) {
    // Sample Generated Reviewers & Files for this subject
    final List<Map<String, dynamic>> reviewers = [
      {
        'title': 'Module 1: Introduction & Architecture',
        'type': 'AI Summary Notes',
        'date': 'Uploaded Aug 5',
        'icon': Icons.description_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Midterm Exam Practice Quiz',
        'type': '20 Multiple Choice Questions',
        'date': 'Generated Aug 6',
        'icon': Icons.quiz_rounded,
        'color': Colors.green,
      },
      {
        'title': 'Key Terms & Definitions',
        'type': '35 Flashcards Set',
        'date': 'Generated Aug 6',
        'icon': Icons.style_rounded,
        'color': Colors.purple,
      },
      {
        'title': 'Lecture Reference Slide PDF',
        'type': 'Original File (PDF)',
        'date': 'Uploaded Aug 4',
        'icon': Icons.picture_as_pdf_rounded,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectCode, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spcbaGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.spcbaGreen.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All uploaded materials and AI-generated review resources.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Reviewer Modules & Files',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // List of Files / AI Content
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviewers.length,
              itemBuilder: (context, index) {
                final item = reviewers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (item['color'] as Color).withValues(alpha: 0.15),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color),
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      '${item['type']} • ${item['date']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${item['title']}...')),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}