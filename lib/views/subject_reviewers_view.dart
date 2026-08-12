import 'package:flutter/material.dart';
import 'subject_detail_view.dart';

class SubjectReviewersView extends StatefulWidget {
  const SubjectReviewersView({super.key});

  @override
  State<SubjectReviewersView> createState() => _SubjectReviewersViewState();
}

class _SubjectReviewersViewState extends State<SubjectReviewersView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _subjects = [
    {
      'code': 'IT 101',
      'title': 'Data Structures & Algorithms',
      'topicsCount': 12,
      'completedTopics': 8,
      'progress': 0.66,
      'icon': Icons.account_tree_rounded,
      'accentColor': const Color(0xFF2563EB),
      'cardBg': const Color(0xFFEFF6FF),
      'gradient': const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      'quizReady': true,
      'flashcardsReady': true,
    },
    {
      'code': 'IT 102',
      'title': 'Web Systems & Technologies',
      'topicsCount': 8,
      'completedTopics': 6,
      'progress': 0.75,
      'icon': Icons.language_rounded,
      'accentColor': const Color(0xFFD97706),
      'cardBg': const Color(0xFFFFFBEB),
      'gradient': const [Color(0xFFF59E0B), Color(0xFFD97706)],
      'quizReady': true,
      'flashcardsReady': true,
    },
    {
      'code': 'IT 103',
      'title': 'Object-Oriented Programming',
      'topicsCount': 10,
      'completedTopics': 4,
      'progress': 0.40,
      'icon': Icons.code_rounded,
      'accentColor': const Color(0xFF9333EA),
      'cardBg': const Color(0xFFFAF5FF),
      'gradient': const [Color(0xFFA855F7), Color(0xFF7E22CE)],
      'quizReady': false,
      'flashcardsReady': true,
    },
    {
      'code': 'IT 104',
      'title': 'Database Management Systems',
      'topicsCount': 15,
      'completedTopics': 12,
      'progress': 0.80,
      'icon': Icons.storage_rounded,
      'accentColor': const Color(0xFF059669),
      'cardBg': const Color(0xFFECFDF5),
      'gradient': const [Color(0xFF10B981), Color(0xFF047857)],
      'quizReady': true,
      'flashcardsReady': true,
    },
    {
      'code': 'IT 105',
      'title': 'Information Assurance & Security',
      'topicsCount': 7,
      'completedTopics': 2,
      'progress': 0.28,
      'icon': Icons.security_rounded,
      'accentColor': const Color(0xFFDC2626),
      'cardBg': const Color(0xFFFEF2F2),
      'gradient': const [Color(0xFFEF4444), Color(0xFFB91C1C)],
      'quizReady': false,
      'flashcardsReady': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _subjects.where((subj) {
      final title = subj['title'].toString().toLowerCase();
      final code = subj['code'].toString().toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) || code.contains(_searchQuery.toLowerCase());
    }).toList();

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
        centerTitle: true,
        title: const Text(
          'Subject Reviewers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAiGeneratorBanner(),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search subject or course code...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E5E2F)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Courses',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  '${filteredSubjects.length} Available',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...filteredSubjects.map((subject) => _buildSubjectCard(subject)),
          ],
        ),
      ),
    );
  }

  Widget _buildAiGeneratorBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFBBF24), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Generate AI Reviewer',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  'Upload your syllabus or lecture notes to auto-create reviewer cards.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5E2F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _showUploadNotesBottomSheet,
            icon: const Icon(Icons.upload_file_rounded, size: 16),
            label: const Text('Upload', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    List<Color> cardGradient = subject['gradient'];
    Color accentColor = subject['accentColor'];
    double progressPct = (subject['progress'] * 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetailView(
                  subjectCode: subject['code'],
                  subjectTitle: subject['title'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: cardGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: cardGradient[0].withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Icon(subject['icon'], color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${subject['code']} • ${subject['topicsCount']} Topics',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mastery Progress',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                        ),
                        Text(
                          '${progressPct.toInt()}%',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: cardGradient[0]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: subject['progress'],
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(cardGradient[0]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (subject['flashcardsReady']) ...[
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening Flashcards for ${subject['code']}...')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.style_rounded, size: 12, color: Color(0xFF475569)),
                              SizedBox(width: 4),
                              Text('🎴 Flashcards', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (subject['quizReady']) ...[
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Starting Practice Quiz for ${subject['code']}!')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF059669)),
                              SizedBox(width: 2),
                              Text('⚡ Take Quiz', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      '${subject['completedTopics']}/${subject['topicsCount']} Done',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadNotesBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('✨ AI Reviewer Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Upload a PDF, Word Doc, or image of your lecture notes to automatically generate flashcards and quizzes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.cloud_upload_rounded, size: 40, color: Color(0xFF1E5E2F)),
                    SizedBox(height: 8),
                    Text('Drag and drop or tap to browse', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Supports PDF, DOCX, PNG up to 25MB', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5E2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Uploading file and generating AI Reviewer... ✨')),
                    );
                  },
                  child: const Text('Generate Reviewer Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}