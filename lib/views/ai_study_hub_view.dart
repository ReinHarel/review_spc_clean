import 'package:flutter/material.dart';
import '../core/constants.dart';

class AiStudyHubView extends StatefulWidget {
  const AiStudyHubView({super.key});

  @override
  State<AiStudyHubView> createState() => _AiStudyHubViewState();
}

class _AiStudyHubViewState extends State<AiStudyHubView> {
  // Dynamic list para sa Irreg students (pwedeng madagdagan)
  List<String> subjects = [
    'IT 101 - Data Structures',
    'IT 102 - Web Systems',
    'IT 103 - OOP',
    'IT 104 - DBMS',
    'IT Spec 2',
    '+ Add Custom Subject (Irreg)',
  ];

  String selectedSubject = 'IT Spec 2';
  final TextEditingController _ytController = TextEditingController();

  // Helper dialog para sa Custom Subject (Irreg Students)
  void _showAddSubjectDialog() {
    TextEditingController customSubjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Subject'),
        content: TextField(
          controller: customSubjectController,
          decoration: const InputDecoration(
            hintText: 'e.g., IT 109 - Mobile Dev',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.spcbaGreen),
            onPressed: () {
              if (customSubjectController.text.trim().isNotEmpty) {
                setState(() {
                  String newSub = customSubjectController.text.trim();
                  subjects.insert(subjects.length - 1, newSub);
                  selectedSubject = newSub;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Content Mismatch Dialog with Best Practice "Override" Button
  void _showMismatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFFFEBEE),
              child: Icon(Icons.cancel_outlined, color: Colors.red, size: 36),
            ),
            const SizedBox(height: 12),
            const Text(
              'Content Mismatch',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Text(
                'The uploaded material appears unrelated to your subject. Please check alignment to maintain study accuracy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text('Expected: $selectedSubject', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const Text('Detected: Biology / Life Sciences', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.spcbaGreen),
                onPressed: () => Navigator.pop(context),
                child: const Text('Try Again', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing document with user override...')),
                  );
                },
                child: const Text('Proceed Anyway', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload & Summarize Reviewers 📄✨',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Drop lecture notes or paste video links to generate instant AI materials.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Subject Tag Dropdown (Irreg-Friendly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text('Tag Subject: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSubject,
                        isExpanded: true,
                        items: subjects.map((String sub) {
                          return DropdownMenuItem<String>(
                            value: sub,
                            child: Text(
                              sub,
                              style: TextStyle(
                                fontSize: 13,
                                color: sub.contains('Custom') ? AppColors.spcbaGreen : Colors.black,
                                fontWeight: sub.contains('Custom') ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue == '+ Add Custom Subject (Irreg)') {
                            _showAddSubjectDialog();
                          } else if (newValue != null) {
                            setState(() {
                              selectedSubject = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source 1: File Upload Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spcbaGreen.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.spcbaGreen.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.spcbaGreen),
                  const SizedBox(height: 8),
                  const Text('Import PDF Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text('Supports PDF, DOCX, PPTX (Max 25MB)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.spcbaGreen),
                    onPressed: _showMismatchDialog, // Demo: Click to trigger Mismatch Dialog test
                    icon: const Icon(Icons.folder_open, color: Colors.white, size: 16),
                    label: const Text('Browse File (Test Mismatch)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Source 2: YouTube Link Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.play_circle_fill, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Paste YouTube Video Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ytController,
                    decoration: const InputDecoration(
                      hintText: 'https://youtube.com/watch?v=...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_ytController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Analyzing YouTube Transcript...')),
                          );
                        }
                      },
                      child: const Text('Process Video Link', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Your Study Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),

            // Document Cards List
            _buildDocCard('Chapter 1 - Intro to Flutter.pdf', 'IT Spec 2 • 2.4 MB'),
            _buildDocCard('Database Normalization Notes.docx', 'IT 104 - DBMS • 1.1 MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.spcbaGreen,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Generating AI Summary for $title...')),
            );
          },
          child: const Text('Summarize ✨', style: TextStyle(color: Colors.white, fontSize: 11)),
        ),
      ),
    );
  }
}