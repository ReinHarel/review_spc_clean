import 'package:flutter/material.dart';

class NotesReaderView extends StatelessWidget {
  final String title;
  final String subjectCode;

  const NotesReaderView({
    super.key,
    required this.title,
    required this.subjectCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Bookmarks!')));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFBBF24)),
        label: const Text('Ask AI Tutor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening AI Tutor Assistant... ✨')),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, color: Color(0xFF2563EB), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Summary • Automatically generated from uploaded slides.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Overview of Data Structures',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data structures are specialized formats for organizing, processing, retrieving, and storing data. They provide a means to manage large amounts of data efficiently for uses such as large databases and internet indexing services.',
              style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Key Concepts & Types',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Linear Data Structures: Arrays, Stacks, Queues, Linked Lists.\n• Non-Linear Data Structures: Trees, Graphs, Hash Tables.\n• Time Complexity: Measures the amount of time an algorithm takes to run as a function of the length of the input.',
              style: TextStyle(fontSize: 13, height: 1.8, color: Color(0xFF334155)),
            ),
          ],
        ),
      ),
    );
  }
}