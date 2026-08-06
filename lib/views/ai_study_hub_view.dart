import 'package:flutter/material.dart';
import '../core/constants.dart';

class AiStudyHubView extends StatefulWidget {
  const AiStudyHubView({super.key});

  @override
  State<AiStudyHubView> createState() => _AiStudyHubViewState();
}

class _AiStudyHubViewState extends State<AiStudyHubView> {
  // Sample data for uploaded reviewer materials
  final List<Map<String, String>> _uploadedFiles = [
    {
      'title': 'Chapter 1 - Introduction to Biology.pdf',
      'size': '2.4 MB',
      'date': 'Aug 05, 2026',
      'type': 'PDF',
    },
    {
      'title': 'Lecture Notes - World History.docx',
      'size': '1.1 MB',
      'date': 'Aug 06, 2026',
      'type': 'DOC',
    },
  ];

  void _simulateFileUpload() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File picker triggered! (Pick a PDF, Image, or DOC)'),
        backgroundColor: AppColors.spcbaGreen,
        duration: Duration(seconds: 2),
      ),
    );
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Upload Reviewer Materials',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.spcbaGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upload your lecture slides, notes, or PDFs to generate AI summaries and quizzes.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Dropzone / File Upload Box
            InkWell(
              onTap: _simulateFileUpload,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.spcbaGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.spcbaGreen.withValues(alpha: 0.3),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.spcbaGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 36,
                        color: AppColors.spcbaGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap to upload reviewer files',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.spcbaGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supports PDF, DOCX, PNG, JPG (Max 25MB)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Section
            Text(
              'Quick AI Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildActionChip(
                    Icons.auto_awesome,
                    'Generate Quiz',
                    Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _buildActionChip(
                    Icons.summarize_outlined,
                    'Summarize File',
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildActionChip(
                    Icons.style_outlined,
                    'Create Flashcards',
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Files List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Reviewers (${_uploadedFiles.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 8),

            // Recent Files List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _uploadedFiles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final file = _uploadedFiles[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.spcbaGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        file['type'] == 'PDF'
                            ? Icons.picture_as_pdf
                            : Icons.description,
                        color: AppColors.spcbaGreen,
                      ),
                    ),
                    title: Text(
                      file['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${file['size']} • Uploaded ${file['date']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$value selected for ${file['title']}',
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Summarize',
                          child: Row(
                            children: [
                              Icon(Icons.summarize, size: 18),
                              SizedBox(width: 8),
                              Text('Summarize'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'Generate Quiz',
                          child: Row(
                            children: [
                              Icon(Icons.quiz, size: 18),
                              SizedBox(width: 8),
                              Text('Generate Quiz'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.08),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label feature clicked!')));
      },
    );
  }
}
