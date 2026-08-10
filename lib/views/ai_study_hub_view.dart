import 'package:flutter/material.dart';

class AiStudyHubView extends StatefulWidget {
  const AiStudyHubView({super.key});

  @override
  State<AiStudyHubView> createState() => _AiStudyHubViewState();
}

class _AiStudyHubViewState extends State<AiStudyHubView> {
  String _selectedSubject = 'IT Spec 2';
  String _selectedAction = 'quiz'; // 'quiz', 'summary', 'flashcards'
  String _selectedFilter = 'All';

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isProcessingVideo = false;

  final TextEditingController _ytController = TextEditingController();

  final List<Map<String, String>> _documents = [
    {
      'title': 'Chapter 1 - Intro to Flutter.pdf',
      'subtitle': 'IT Spec 2 • 2.4 MB',
      'type': 'PDF',
    },
    {
      'title': 'Database Normalization Notes.docx',
      'subtitle': 'IT 104 - DBMS • 1.1 MB',
      'type': 'DOCX',
    },
  ];

  void _simulateFileUpload() {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate progress animation
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_uploadProgress < 1.0) {
        setState(() {
          _uploadProgress += 0.2;
        });
        return true;
      }
      return false;
    }).then((_) {
      setState(() {
        _isUploading = false;
        _documents.insert(0, {
          'title': 'Uploaded_Lecture_Notes_${_documents.length + 1}.pdf',
          'subtitle': '$_selectedSubject • 3.2 MB',
          'type': 'PDF',
        });
      });

      if (!mounted) return; // 👈 DITO ILALAGAY

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 File uploaded & processed successfully!'),
          backgroundColor: Color(0xFF1E5E2F),
        ),
      );
    });
  }

  void _processYoutubeLink() {
    if (_ytController.text.trim().isEmpty) return;

    setState(() {
      _isProcessingVideo = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessingVideo = false;
          _ytController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ YouTube video converted to study notes!'),
            backgroundColor: Color(0xFF1E5E2F),
          ),
        );
      }
    });
  }

  List<Map<String, String>> get _filteredDocuments {
    if (_selectedFilter == 'All') return _documents;
    return _documents.where((doc) => doc['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Study Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER TITLE
            const Text(
              'Upload & Generate AI Materials 📄✨',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Upload lecture notes, PDFs, or paste YouTube video links to create instant quizzes and summaries.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),

            // 1. SUBJECT TAG DROPDOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF1E5E2F), size: 20),
                  const SizedBox(width: 10),
                  const Text('Tag Subject: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubject,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        style: const TextStyle(color: Color(0xFF1E5E2F), fontWeight: FontWeight.bold, fontSize: 13),
                        items: ['IT Spec 2', 'IT 104 - DBMS', 'Accounting 101']
                            .map((subj) => DropdownMenuItem(value: subj, child: Text(subj)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSubject = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. DRAG & DROP / BROWSE AREA WITH UPLOAD ANIMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFDCFCE7),
                    child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF15803D), size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Drag & Drop or Import Notes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Supports PDF, DOCX, PPTX (Max 25MB)',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  if (_isUploading) ...[
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF1E5E2F),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uploading... ${(_uploadProgress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E5E2F)),
                    ),
                  ] else
                    ElevatedButton.icon(
                      onPressed: _simulateFileUpload,
                      icon: const Icon(Icons.folder_open_rounded, size: 18),
                      label: const Text('Browse Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E5E2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. YOUTUBE VIDEO CONVERTER FIELD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_fill_rounded, color: Colors.red, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _ytController,
                      decoration: const InputDecoration(
                        hintText: 'Paste YouTube Video Link...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isProcessingVideo ? null : _processYoutubeLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E5E2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isProcessingVideo
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Process'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. QUICK AI ACTIONS (INTERACTIVE SELECTION)
            const Text(
              'Quick AI Actions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    id: 'quiz',
                    title: 'Generate Quiz',
                    icon: Icons.auto_awesome_rounded,
                    bgColor: const Color(0xFFFF9800),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    id: 'summary',
                    title: 'Summarize',
                    icon: Icons.article_rounded,
                    bgColor: const Color(0xFFE0F2FE),
                    textColor: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    id: 'flashcards',
                    title: 'Flashcards',
                    icon: Icons.style_rounded,
                    bgColor: const Color(0xFFF3E8FF),
                    textColor: const Color(0xFF7E22CE),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. DOCUMENTS LIST HEADER & FILTERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Study Documents',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Row(
                  children: ['All', 'PDF', 'DOCX'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1E5E2F) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // DOCUMENT CARDS LIST
            ..._filteredDocuments.map((doc) => _buildDocCard(doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String id,
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    final isSelected = _selectedAction == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedAction = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF1E5E2F), width: 2.5) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 3))]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocCard(Map<String, String> doc) {
    final isPdf = doc['type'] == 'PDF';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPdf ? Colors.red.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
              color: isPdf ? Colors.red : Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(doc['subtitle']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF1E5E2F), size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generating AI Quiz for ${doc['title']}...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sports_esports_rounded, color: Color(0xFF0284C7), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}