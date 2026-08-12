import 'package:flutter/material.dart';
import 'quiz_hub_view.dart';
import 'notes_reader_view.dart';
import 'flashcard_view.dart';

class SubjectDetailView extends StatelessWidget {
  final String subjectCode;
  final String subjectTitle;

  const SubjectDetailView({
    super.key,
    required this.subjectCode,
    required this.subjectTitle,
  });

  final List<Map<String, dynamic>> _modules = const [
    {
      'type': 'notes',
      'modeIndex': 1,
      'title': 'Module 1: Introduction & Architecture',
      'subtitle': 'AI Summary Notes • Uploaded Aug 5',
      'icon': Icons.description_rounded,
      'color': Color(0xFF2563EB),
      'bgColor': Color(0xFFEFF6FF),
    },
    {
      'type': 'quiz',
      'modeIndex': 0,
      'title': 'Midterm Exam Practice Quiz',
      'subtitle': '20 Multiple Choice Questions • Generated Aug 6',
      'icon': Icons.help_outline_rounded,
      'color': Color(0xFF059669),
      'bgColor': Color(0xFFECFDF5),
    },
    {
      'type': 'flashcards',
      'modeIndex': 3,
      'title': 'Key Terms & Definitions',
      'subtitle': '35 Flashcards Set • Generated Aug 6',
      'icon': Icons.style_rounded,
      'color': Color(0xFF9333EA),
      'bgColor': Color(0xFFFAF5FF),
    },
    {
      'type': 'pdf',
      'modeIndex': 1,
      'title': 'Lecture Reference Slide PDF',
      'subtitle': 'Original File (PDF) • Uploaded Aug 4',
      'icon': Icons.picture_as_pdf_rounded,
      'color': Color(0xFFDC2626),
      'bgColor': Color(0xFFFEF2F2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E5E2F), Color(0xFF0F381B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subjectCode,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'All uploaded materials and AI-generated review resources.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviewer Modules & Files',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  '${_modules.length} Items',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._modules.map((item) => _buildModuleCard(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> item) {
    Color itemColor = item['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final String itemType = item['type'] ?? '';

          if (itemType == 'notes' || itemType == 'pdf') {
            // Module 1 Notes & Reference PDF -> Notes Reader View
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotesReaderView(
                  title: item['title'],
                  subjectCode: subjectCode,
                ),
              ),
            );
          } else if (itemType == 'flashcards') {
            // Key Terms -> Flashcards View
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardView(
                  title: item['title'],
                ),
              ),
            );
          } else {
            // Practice Quiz -> Quiz Hub View
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizHubView(
                  initialModeIndex: item['modeIndex'] ?? 0,
                  subjectTitle: subjectTitle,
                  subjectCode: subjectCode,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item['bgColor'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'], color: itemColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
            ],
          ),
        ),
      ),
    );
  }
}