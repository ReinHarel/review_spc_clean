import 'dart:math';
import 'package:flutter/material.dart';

class FlashcardView extends StatefulWidget {
  final String title;

  const FlashcardView({
    super.key,
    required this.title,
  });

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showAnswer = false;
  
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<int> _masteredIndexes = [];
  final List<int> _learningIndexes = [];

  final List<Map<String, String>> _flashcards = [
    {
      'question': 'What is a Binary Search Tree (BST)?',
      'answer': 'A node-based binary tree data structure which has the property that the left subtree of a node contains only nodes with keys lesser than the node\'s key.',
    },
    {
      'question': 'What is the time complexity of QuickSort in average case?',
      'answer': 'O(n log n)',
    },
    {
      'question': 'What is the difference between Stack and Queue?',
      'answer': 'Stack follows Last-In, First-Out (LIFO), whereas Queue follows First-In, First-Out (FIFO).',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showAnswer) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _markCard(bool isMastered) {
    setState(() {
      if (isMastered) {
        if (!_masteredIndexes.contains(_currentIndex)) {
          _masteredIndexes.add(_currentIndex);
        }
      } else {
        if (!_learningIndexes.contains(_currentIndex)) {
          _learningIndexes.add(_currentIndex);
        }
      }

      if (_currentIndex < _flashcards.length - 1) {
        _currentIndex++;
        _showAnswer = false;
        _controller.reset(); // Reset animation for next card
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _resetFlashcards() {
    setState(() {
      _currentIndex = 0;
      _showAnswer = false;
      _masteredIndexes.clear();
      _learningIndexes.clear();
      _controller.reset();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Color(0xFF10B981), size: 28),
            SizedBox(width: 8),
            Text('Set Completed!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Great job reviewing ${widget.title}!'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('${_masteredIndexes.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      const Text('Mastered', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  Column(
                    children: [
                      Text('${_learningIndexes.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                      const Text('Learning', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetFlashcards();
            },
            child: const Text('Restart All'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5E2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _flashcards[_currentIndex];
    final double progress = (_currentIndex + 1) / _flashcards.length;

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
          widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _resetFlashcards,
            tooltip: 'Restart Flashcards',
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of ${_flashcards.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_masteredIndexes.length} Mastered',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
                ),
              ),
              const SizedBox(height: 24),

              // 🚀 REAL 3D ROTATION CARD
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final transformValue = _animation.value * pi;
                      final isUnderHalf = _animation.value < 0.5;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // 3D Perspective
                          ..rotateY(transformValue),
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isUnderHalf ? Colors.white : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isUnderHalf ? const Color(0xFFE2E8F0) : const Color(0xFF3B82F6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(32),
                          // Rotate the content back so text isn't mirrored!
                          child: Transform(
                            transform: Matrix4.identity()..rotateY(isUnderHalf ? 0 : pi),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isUnderHalf ? const Color(0xFFF1F5F9) : const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isUnderHalf ? 'QUESTION' : 'ANSWER',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: isUnderHalf ? const Color(0xFF64748B) : const Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  isUnderHalf ? currentCard['question']! : currentCard['answer']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isUnderHalf ? 20 : 18,
                                    fontWeight: isUnderHalf ? FontWeight.bold : FontWeight.w500,
                                    color: const Color(0xFF0F172A),
                                    height: 1.4,
                                  ),
                                ),
                                const Spacer(),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.touch_app_rounded, size: 16, color: Color(0xFF94A3B8)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Tap card to flip',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => _markCard(false),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 20),
                          SizedBox(width: 8),
                          Text('Still Learning', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF10B981),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => _markCard(true),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Mastered', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}