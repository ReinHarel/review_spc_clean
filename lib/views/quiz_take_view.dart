import 'package:flutter/material.dart';

class QuizTakeView extends StatefulWidget {
  final String quizTitle;
  final String subjectCode;

  const QuizTakeView({
    super.key,
    required this.quizTitle,
    required this.subjectCode,
  });

  @override
  State<QuizTakeView> createState() => _QuizTakeViewState();
}

class _QuizTakeViewState extends State<QuizTakeView> {
  int _currentIndex = 0;
  int? _selectedOption;
  int _score = 0;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the time complexity of searching in a balanced Binary Search Tree (BST)?',
      'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
      'correctIndex': 2,
    },
    {
      'question': 'Which data structure operates on a Last-In, First-Out (LIFO) basis?',
      'options': ['Queue', 'Stack', 'Array', 'Linked List'],
      'correctIndex': 1,
    },
    {
      'question': 'What technique is used in QuickSort to divide the array?',
      'options': ['Greedy Method', 'Dynamic Programming', 'Partitioning with Pivot', 'Brute Force'],
      'correctIndex': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.subjectCode} • Quiz',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 12),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
                minHeight: 8,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
              ),
            ),
            const SizedBox(height: 24),

            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                currentQ['question'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.4),
              ),
            ),
            const SizedBox(height: 20),

            // Options List
            Expanded(
              child: ListView.builder(
                itemCount: (currentQ['options'] as List).length,
                itemBuilder: (context, index) {
                  final optionText = currentQ['options'][index];
                  final isSelected = _selectedOption == index;
                  final isCorrect = currentQ['correctIndex'] == index;

                  Color borderCol = const Color(0xFFE2E8F0);
                  Color bgCol = Colors.white;

                  if (_answered) {
                    if (isCorrect) {
                      bgCol = const Color(0xFFECFDF5);
                      borderCol = const Color(0xFF10B981);
                    } else if (isSelected) {
                      bgCol = const Color(0xFFFEF2F2);
                      borderCol = const Color(0xFFEF4444);
                    }
                  } else if (isSelected) {
                    bgCol = const Color(0xFFEFF6FF);
                    borderCol = const Color(0xFF3B82F6);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _answered
                          ? null
                          : () {
                              setState(() {
                                _selectedOption = index;
                              });
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: bgCol,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderCol, width: isSelected || (_answered && isCorrect) ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isSelected ? borderCol : const Color(0xFFF1F5F9),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                optionText,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Submit / Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _selectedOption == null
                    ? null
                    : () {
                        if (!_answered) {
                          setState(() {
                            _answered = true;
                            if (_selectedOption == currentQ['correctIndex']) {
                              _score++;
                            }
                          });
                        } else {
                          if (_currentIndex < _questions.length - 1) {
                            setState(() {
                              _currentIndex++;
                              _selectedOption = null;
                              _answered = false;
                            });
                          } else {
                            _showResultDialog();
                          }
                        }
                      },
                child: Text(
                  !_answered
                      ? 'Submit Answer'
                      : (_currentIndex < _questions.length - 1 ? 'Next Question ➔' : 'View Quiz Result'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Quiz Completed!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You scored $_score out of ${_questions.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text('Great job studying! Keeping your streak alive! ⚡', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5E2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to Subject Detail View
              },
              child: const Text('Back to Reviewer'),
            ),
          ),
        ],
      ),
    );
  }
}