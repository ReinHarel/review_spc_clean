import 'package:flutter/material.dart';
import '../core/constants.dart';

class QuizHubView extends StatefulWidget {
  const QuizHubView({super.key});

  @override
  State<QuizHubView> createState() => _QuizHubViewState();
}

class _QuizHubViewState extends State<QuizHubView> {
  int _activeTabIndex = 0; // 0 for Flashcards, 1 for Quiz Mode

  // Sample Flashcards Data
  final List<Map<String, String>> _flashcards = [
    {
      'question': 'What is Photosynthesis?',
      'answer':
          'The process by which green plants use sunlight to synthesize nutrients from carbon dioxide and water.',
    },
    {
      'question': 'What is the powerhouse of the cell?',
      'answer': 'Mitochondria!',
    },
    {'question': 'Who wrote "Noli Me Tangere"?', 'answer': 'Dr. Jose Rizal.'},
  ];

  int _currentCardIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz & Flashcards'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selector Segmented Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _activeTabIndex == 0
                          ? AppColors.spcbaGreen
                          : Colors.grey.shade200,
                      foregroundColor: _activeTabIndex == 0
                          ? Colors.white
                          : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => setState(() => _activeTabIndex = 0),
                    icon: const Icon(Icons.style),
                    label: const Text('Flashcards'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _activeTabIndex == 1
                          ? AppColors.spcbaGreen
                          : Colors.grey.shade200,
                      foregroundColor: _activeTabIndex == 1
                          ? Colors.white
                          : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => setState(() => _activeTabIndex = 1),
                    icon: const Icon(Icons.quiz),
                    label: const Text('Quiz Mode'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tab Content
            _activeTabIndex == 0
                ? _buildFlashcardSection()
                : _buildQuizModeSection(),
          ],
        ),
      ),
    );
  }

  // --- FLASHCARD SECTION ---
  Widget _buildFlashcardSection() {
    final currentCard = _flashcards[_currentCardIndex];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Card ${_currentCardIndex + 1} of ${_flashcards.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showAnswer = !_showAnswer;
                });
              },
              icon: const Icon(Icons.flip_camera_android),
              label: const Text('Flip Card'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Flip Card UI
        GestureDetector(
          onTap: () {
            setState(() {
              _showAnswer = !_showAnswer;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _showAnswer
                  ? Colors.amber.withValues(alpha: 0.15)
                  : AppColors.spcbaGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _showAnswer
                    ? Colors.amber.shade700
                    : AppColors.spcbaGreen,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showAnswer ? 'ANSWER' : 'QUESTION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: _showAnswer
                        ? Colors.orange.shade800
                        : AppColors.spcbaGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _showAnswer
                      ? currentCard['answer']!
                      : currentCard['question']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap to flip',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Navigation Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.filledTonal(
              iconSize: 28,
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentCardIndex > 0
                  ? () {
                      setState(() {
                        _currentCardIndex--;
                        _showAnswer = false;
                      });
                    }
                  : null,
            ),
            IconButton.filledTonal(
              iconSize: 28,
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentCardIndex < _flashcards.length - 1
                  ? () {
                      setState(() {
                        _currentCardIndex++;
                        _showAnswer = false;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  // --- QUIZ MODE SECTION ---
  Widget _buildQuizModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Quiz Category',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildQuizCategoryCard(
          'Biology 101 - Cell Division',
          '10 Questions • 15 Mins',
          Icons.biotech,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildQuizCategoryCard(
          'Philippine History - Midterms',
          '15 Questions • 20 Mins',
          Icons.history_edu,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildQuizCategoryCard(
          'Computer Programming - Dart & Flutter',
          '20 Questions • 30 Mins',
          Icons.code,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildQuizCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Starting Quiz: $title')));
        },
      ),
    );
  }
}
