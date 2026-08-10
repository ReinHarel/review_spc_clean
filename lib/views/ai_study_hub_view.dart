import 'package:flutter/material.dart';

import 'quiz_hub_view.dart';

class AiStudyHubView extends StatefulWidget {
  const AiStudyHubView({super.key});

  @override
  State<AiStudyHubView> createState() => _AiStudyHubViewState();
}

class _AiStudyHubViewState extends State<AiStudyHubView> {
  String _selectedSubject = 'IT Spec 2';
  final TextEditingController _youtubeController = TextEditingController();
  int _selectedActionIndex = 0; // 0: Quiz, 1: Summary, 2: Flashcards

  final List<String> _subjects = [
    'IT Spec 2',
    'IT 104 - DBMS',
    'Data Structures & Algorithms',
    'Web Systems & Tech',
  ];

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AI Study Hub',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
                  // 1. HEADER TITLE & SUBTITLE
                  const Text(
                    'Upload & Generate AI Materials 📄✨',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upload lecture notes, PDFs, or paste YouTube video links to create instant quizzes and summaries.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. SUBJECT SELECTION DROPDOWN
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_border_rounded, color: Color(0xFF1E5E2F), size: 20),
                        const SizedBox(width: 10),
                        const Text(
                          'Tag Subject: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSubject,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E5E2F),
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedSubject = newValue;
                                  });
                                }
                              },
                              items: _subjects.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. DROPZONE / UPLOAD FILE BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            size: 32,
                            color: Color(0xFF1E5E2F),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Drag & Drop or Import Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Supports PDF, DOCX, PPTX (Max 25MB)',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening file picker...')),
                            );
                          },
                          icon: const Icon(Icons.folder_open_rounded, size: 16),
                          label: const Text('Browse Files'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E5E2F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. YOUTUBE LINK INPUT FIELD
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.play_circle_fill_rounded, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Paste YouTube Video Link',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: TextField(
                                  controller: _youtubeController,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'https://youtube.com/watch?v=...',
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_youtubeController.text.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing video transcript...')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E5E2F),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Process', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. QUICK AI ACTIONS (3 INTERACTIVE CARDS)
                  const Text(
                    'Quick AI Actions',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAiActionCard(
                          index: 0,
                          title: 'Generate Quiz',
                          icon: Icons.auto_awesome_rounded,
                          accentColor: Colors.amber.shade800,
                          bgColor: const Color(0xFFFFF8E1),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAiActionCard(
                          index: 1,
                          title: 'Summarize',
                          icon: Icons.article_rounded,
                          accentColor: Colors.blue.shade700,
                          bgColor: const Color(0xFFE3F2FD),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAiActionCard(
                          index: 2,
                          title: 'Flashcards',
                          icon: Icons.style_rounded,
                          accentColor: Colors.purple.shade700,
                          bgColor: const Color(0xFFF3E5F5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 6. YOUR STUDY DOCUMENTS LIST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Your Study Documents',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E5E2F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildDocumentCard(
                    title: 'Chapter 1 - Intro to Flutter.pdf',
                    subtitle: 'IT Spec 2 • 2.4 MB',
                    fileType: 'pdf',
                  ),
                  _buildDocumentCard(
                    title: 'Database Normalization Notes.docx',
                    subtitle: 'IT 104 - DBMS • 1.1 MB',
                    fileType: 'doc',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildAiActionCard({
    required int index,
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
  }) {
    final bool isSelected = _selectedActionIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActionIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accentColor : accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : accentColor,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required String fileType,
  }) {
    final isPdf = fileType == 'pdf';
    final iconColor = isPdf ? Colors.red.shade700 : Colors.blue.shade700;
    final iconBg = isPdf ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Action Buttons per File
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF1E5E2F), size: 18),
                tooltip: 'Summarize with AI',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Generating AI Summary for $title...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.sports_esports_rounded, color: Color(0xFF1976D2), size: 18),
                tooltip: 'Take Quiz',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHubView()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}