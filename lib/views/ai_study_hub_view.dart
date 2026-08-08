import 'package:flutter/material.dart';
import '../core/constants.dart';

class AiStudyHubView extends StatefulWidget {
  const AiStudyHubView({super.key});

  @override
  State<AiStudyHubView> createState() => _AiStudyHubViewState();
}

class _AiStudyHubViewState extends State<AiStudyHubView> {
  String _selectedSubject = 'IT Spec 2';
  bool _isGeneratingSummary = false;
  bool _hasSelectedFile = false;
  String _activeFileName = '';

  final List<String> _subjects = [
    'IT Spec 2',
    'Data Structures',
    'Database Management',
    'Accounting 101',
    'General Education'
  ];

  // Dummy list ng sample uploaded reviewers
  final List<Map<String, String>> _uploadedFiles = [
    {
      'title': 'Chapter 1 - Intro to Flutter & Dart.pdf',
      'subject': 'IT Spec 2',
      'size': '2.4 MB',
      'date': 'Today, 10:15 AM'
    },
    {
      'title': 'Database Normalization Notes.docx',
      'subject': 'Database Management',
      'size': '1.1 MB',
      'date': 'Yesterday'
    },
  ];

  void _simulateFileUpload() {
    setState(() {
      _hasSelectedFile = true;
      _activeFileName = 'MIDTERM_REVIEWER_2026.pdf';
      _uploadedFiles.insert(0, {
        'title': _activeFileName,
        'subject': _selectedSubject,
        'size': '3.8 MB',
        'date': 'Just now'
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploaded $_activeFileName successfully!'),
        backgroundColor: AppColors.spcbaGreen,
      ),
    );
  }

  void _generateAiSummary(String fileName) {
    setState(() {
      _isGeneratingSummary = true;
      _activeFileName = fileName;
    });

    // Simulate AI delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGeneratingSummary = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Hub'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            const Text(
              'Upload & Summarize Reviewers 📄✨',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Drop your lecture slides, notes, or PDFs below to generate instant AI study guides.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // ==================== UPLOAD CARD CONTAINER ====================
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              color: Colors.teal.shade50.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: AppColors.spcbaGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Drag & Drop your study materials here',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supports PDF, DOCX, and PPTX (Max 25MB)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),

                    // Subject Selector before upload
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tag Subject: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        DropdownButton<String>(
                          value: _selectedSubject,
                          underline: const SizedBox(),
                          items: _subjects.map((subj) {
                            return DropdownMenuItem(
                              value: subj,
                              child: Text(subj, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedSubject = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Browse File Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.spcbaGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _simulateFileUpload,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Browse Local File'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ==================== UPLOADED FILES SECTION ====================
            const Text(
              'Your Study Documents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = _uploadedFiles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.picture_as_pdf, color: Colors.red.shade700),
                    ),
                    title: Text(
                      file['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${file['subject']} • ${file['size']} • ${file['date']}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _generateAiSummary(file['title']!),
                          icon: const Icon(Icons.auto_awesome, size: 14),
                          label: const Text('Summarize', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // ==================== AI SUMMARY RESULT PANEL ====================
            if (_isGeneratingSummary)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.spcbaGreen),
                      SizedBox(height: 12),
                      Text('AI is reading and summarizing your document... 🧠✨'),
                    ],
                  ),
                ),
              )
            else if (_activeFileName.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.spcbaGreen.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'AI Summary: $_activeFileName',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.spcbaGreen,
                            ),
                          ),
                        ),
                        Chip(
                          avatar: const Icon(Icons.check_circle, size: 14, color: Colors.green),
                          label: const Text('Ready', style: TextStyle(fontSize: 11)),
                          backgroundColor: Colors.green.shade50,
                        )
                      ],
                    ),
                    const Divider(height: 20),
                    const Text(
                      '📌 Key Summary Points:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryBullet('Introduction to core architectural components and state management.'),
                    _buildSummaryBullet('Key differences between Stateless and Stateful Widgets in responsive layouts.'),
                    _buildSummaryBullet('Best practices for structuring Clean Code in Flutter Web projects.'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.style, size: 16),
                          label: const Text('Generate Flashcards'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.quiz, size: 16),
                          label: const Text('Create Quiz'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}