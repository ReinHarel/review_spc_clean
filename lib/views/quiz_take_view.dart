import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_progress.dart';

// ── Dashed-border painter for empty Sequence Order slots ─────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({required this.color, this.borderRadius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    if (metrics.isEmpty) return;
    final metric = metrics.first;

    const double dashWidth = 8;
    const double dashSpace = 5;
    double distance = 0;
    while (distance < metric.length) {
      final start = metric.getTangentForOffset(distance)?.position;
      final endDist = (distance + dashWidth).clamp(0.0, metric.length);
      final end = metric.getTangentForOffset(endDist)?.position;
      if (start != null && end != null) canvas.drawLine(start, end, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

// ── Main view ────────────────────────────────────────────────────────

class QuizTakeView extends StatefulWidget {
  final String quizTitle;
  final String subjectCode;
  final VoidCallback? onPreTestComplete;
  final VoidCallback? onPracticeModeComplete;

  const QuizTakeView({
    super.key,
    required this.quizTitle,
    required this.subjectCode,
    this.onPreTestComplete,
    this.onPracticeModeComplete,
  });

  static bool isFillBlankAnswerCorrect(
    String answer,
    List<String> acceptedAnswers,
  ) {
    final normalizedInput = answer
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
    return acceptedAnswers.any((candidate) {
      final normalizedCandidate = candidate
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), ' ');
      return normalizedInput == normalizedCandidate;
    });
  }

  @override
  State<QuizTakeView> createState() => _QuizTakeViewState();
}

class _QuizTakeViewState extends State<QuizTakeView>
    with WidgetsBindingObserver {
  // ── Quiz state ─────────────────────────────────────────────────────
  int _currentIndex = 0;
  int? _selectedOption;
  int _pointsEarned = 0;
  bool _answered = false;
  DateTime? _startTime;
  late final Timer _ticker;

  // ── Anti-cheat ─────────────────────────────────────────────────────
  int _antiCheatViolations = 0;
  bool _antiCheatTerminated = false;
  static const int _maxViolations = 3;
  static const int _xpPenaltyPerViolation = 20;

  // ── Sequence state ─────────────────────────────────────────────────
  List<String?> _targetSlots = [];
  List<String> _availableItems = [];
  int? _selectedAvailableIndex;
  bool _sequenceChecked = false;

  // ── Active-recall state ────────────────────────────────────────────
  final TextEditingController _recallController = TextEditingController();
  bool _recallChecked = false;
  double _similarityScore = 0.0;
  List<Map<String, String>> _keyConceptResults = [];

  // ── Fill-in-the-blanks state ──────────────────────────────────────
  final TextEditingController _fillBlankController = TextEditingController();
  bool _fillBlankChecked = false;
  bool _fillBlankCorrect = false;

  // ── Question bank ──────────────────────────────────────────────────
  late final List<Map<String, dynamic>> _questions;
  late final int _maxPoints;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });

    _questions = [
      {
        'type': 'mcq',
        'question':
            'What is the time complexity of searching in a balanced Binary Search Tree (BST)?',
        'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
        'correctIndex': 2,
        'points': 10,
      },
      {
        'type': 'mcq',
        'question':
            'Which data structure operates on a Last-In, First-Out (LIFO) basis?',
        'options': ['Queue', 'Stack', 'Array', 'Linked List'],
        'correctIndex': 1,
        'points': 10,
      },
      {
        'type': 'sequence',
        'question':
            'Arrange the steps of the QuickSort algorithm in the correct order:',
        'sequence': <String>[
          'Choose a Pivot element',
          'Partition the array around pivot',
          'Recurse on left sub-array',
          'Recurse on right sub-array',
          'Merge sorted sub-arrays',
        ],
        'points': 15,
      },
      {
        'type': 'recall',
        'question':
            'Explain what Dynamic Programming is and describe two key properties it requires.',
        'modelAnswer':
            'Dynamic Programming is an algorithmic technique that solves complex problems by breaking them into overlapping subproblems. '
            'It stores the results of subproblems to avoid redundant computation. '
            'Two key properties are optimal substructure and overlapping subproblems.',
        'keyConcepts': <String>[
          'dynamic programming',
          'overlapping subproblems',
          'optimal substructure',
          'memoization',
          'tabulation',
        ],
        'points': 15,
      },
      {
        'type': 'sequence',
        'question':
            'Arrange the steps of the TCP 3-way handshake in the correct order:',
        'sequence': <String>[
          'Send SYN packet',
          'Receive SYN-ACK',
          'Send ACK packet',
        ],
        'points': 10,
      },
      {
        'type': 'fill_blank',
        'question':
            'Complete the accounting equation: Assets = _____ + Equity.',
        'acceptedAnswers': <String>['liabilities', 'liability'],
        'promptHint': 'Type the missing term here...',
        'points': 10,
      },
    ];

    _maxPoints = _questions.fold<int>(0, (s, q) => s + (q['points'] as int));
    _initSequenceSlots(0);
  }

  @override
  void dispose() {
    _ticker.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _recallController.dispose();
    _fillBlankController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ANTI-CHEAT
  // ═══════════════════════════════════════════════════════════════════

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _handleAntiCheatViolation();
  }

  void _handleAntiCheatViolation() {
    if (_antiCheatTerminated || _answered) return;
    setState(() => _antiCheatViolations++);

    if (_antiCheatViolations >= _maxViolations + 1) {
      _antiCheatTerminated = true;
      _terminateQuiz();
    } else {
      _showAntiCheatWarning();
    }
  }

  void _showAntiCheatWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Warning',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'Tab-switching detected! ($_antiCheatViolations/$_maxViolations warnings)\n\n'
          'Continuing to switch will auto-terminate this quiz and deduct XP.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'I Understand',
              style: TextStyle(
                color: Color(0xFF1E5E2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _terminateQuiz() {
    _saveProgressToStore();
    if (mounted) {
      _showTerminationDialog();
    }
  }

  void _recordMistakeForCurrentQuestion() {
    final q = _questions[_currentIndex];
    final type = q['type'] as String;
    final concepts = <String>[];

    if (type == 'mcq') {
      concepts.add(q['question'] as String);
    } else if (type == 'sequence') {
      concepts.addAll(List<String>.from(q['sequence'] as List));
    } else if (type == 'recall') {
      concepts.addAll(List<String>.from(q['keyConcepts'] as List));
    }

    GameProgressStore.instance.recordMistake(
      question: q['question'] as String,
      concepts: concepts,
    );
  }

  void _showTerminationDialog() {
    final int penalty = _antiCheatViolations * _xpPenaltyPerViolation;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.gpp_bad_rounded, color: Colors.red.shade700, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Quiz Terminated',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Quiz Terminated Due to Anti-Cheat Violations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You exceeded the maximum of $_maxViolations tab-switching violations.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            _penaltyRow(
              Icons.remove_circle_outline,
              'XP Deduction',
              '-$penalty XP',
              Colors.red,
            ),
            const SizedBox(height: 6),
            _penaltyRow(
              Icons.grade_outlined,
              'Quiz Grade',
              'Marked as Incomplete',
              Colors.orange,
            ),
            const SizedBox(height: 6),
            _penaltyRow(
              Icons.lock_outline,
              'Badge Progress',
              'Paused for this session',
              Colors.grey.shade600,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5E2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text(
                'Back to Reviewer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SEQUENCE ORDER
  // ═══════════════════════════════════════════════════════════════════

  void _initSequenceSlots(int questionIndex) {
    final q = _questions[questionIndex];
    if (q['type'] != 'sequence') return;
    final list = List<String>.from(q['sequence'] as List);
    _targetSlots = List<String?>.filled(list.length, null);
    _availableItems = list..shuffle();
    _selectedAvailableIndex = null;
    _sequenceChecked = false;
  }

  bool get _allSlotsFilled => _targetSlots.every((s) => s != null);

  void _checkSequenceOrder() {
    final q = _questions[_currentIndex];
    final correct = List<String>.from(q['sequence'] as List);
    final user = List<String>.from(_targetSlots.cast<String>());
    setState(() {
      _sequenceChecked = true;
      if (user == correct) {
        _pointsEarned += q['points'] as int;
      } else {
        _recordMistakeForCurrentQuestion();
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ACTIVE RECALL
  // ═══════════════════════════════════════════════════════════════════

  double _calcSimilarity(String userText, String modelText) {
    if (userText.trim().isEmpty) return 0.0;
    final uWords = userText
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .toSet();
    final mWords = modelText
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .toSet();
    if (mWords.isEmpty) return 0.0;
    return ((uWords.intersection(mWords).length / mWords.length) * 100).clamp(
      0.0,
      100.0,
    );
  }

  List<Map<String, String>> _conceptResults(
    String userText,
    List<String> concepts,
  ) {
    return concepts.map((c) {
      final found = userText.toLowerCase().contains(c.toLowerCase());
      return {'concept': c, 'status': found ? 'found' : 'missing'};
    }).toList();
  }

  void _checkRecallAnswer() {
    final q = _questions[_currentIndex];
    final user = _recallController.text;
    final model = q['modelAnswer'] as String;
    final concepts = List<String>.from(q['keyConcepts'] as List);
    setState(() {
      _similarityScore = _calcSimilarity(user, model);
      _keyConceptResults = _conceptResults(user, concepts);
      _recallChecked = true;
      if (_similarityScore >= 60.0) {
        _pointsEarned += q['points'] as int;
      } else {
        _recordMistakeForCurrentQuestion();
      }
    });
  }

  void _checkFillBlankAnswer() {
    final q = _questions[_currentIndex];
    final user = _fillBlankController.text;
    final accepted = List<String>.from(q['acceptedAnswers'] as List);
    setState(() {
      _fillBlankChecked = true;
      _fillBlankCorrect = QuizTakeView.isFillBlankAnswerCorrect(user, accepted);
      if (_fillBlankCorrect) {
        _pointsEarned += q['points'] as int;
      } else {
        _recordMistakeForCurrentQuestion();
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════
  //  NAVIGATION / SCORING
  // ═══════════════════════════════════════════════════════════════════

  void _submitAnswer() {
    final q = _questions[_currentIndex];
    setState(() {
      _answered = true;
      if (q['type'] == 'mcq' && _selectedOption == q['correctIndex']) {
        _pointsEarned += q['points'] as int;
      } else if (q['type'] == 'mcq') {
        _recordMistakeForCurrentQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
        _recallChecked = false;
        _similarityScore = 0.0;
        _keyConceptResults = [];
        _recallController.clear();
        _fillBlankChecked = false;
        _fillBlankCorrect = false;
        _fillBlankController.clear();
        if (_questions[_currentIndex]['type'] == 'sequence') {
          _initSequenceSlots(_currentIndex);
        }
      });
    } else {
      _finishQuiz();
    }
  }

  void _saveProgressToStore() {
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    final acc = _maxPoints > 0
        ? ((_pointsEarned / _maxPoints) * 100).round()
        : 0;
    final penalty = _antiCheatViolations * _xpPenaltyPerViolation;

    GameProgressStore.instance.recordQuizCompletion(
      accuracyPercent: acc,
      xpEarned: _pointsEarned,
      antiCheatPenalty: penalty,
      antiCheatWarnings: _antiCheatViolations,
      wasUnderTwoMinutes: elapsed < 120,
    );
  }

  void _finishQuiz() {
    _saveProgressToStore();
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    final acc = _maxPoints > 0
        ? ((_pointsEarned / _maxPoints) * 100).round()
        : 0;
    final penalty = _antiCheatViolations * _xpPenaltyPerViolation;
    final xp = max(0, _pointsEarned - penalty);
    _showResultDialog(acc, xp, elapsed);
  }

  void _showResultDialog(int accuracy, int xpEarned, int elapsedSec) {
    final m = elapsedSec ~/ 60;
    final s = elapsedSec % 60;
    final prog = GameProgressStore.instance.progress;
    final growthPercent = (accuracy - 45).clamp(0, 100);
    final focusTopics = GameProgressStore.instance.reviewMistakes.isNotEmpty
        ? GameProgressStore.instance.reviewMistakes.take(3).toList()
        : ['Data Structures', 'Recall Strategy', 'Time Complexity'];

    // Determine quiz type for dynamic CTA
    final isPreTest =
        widget.quizTitle.contains('Pre') ||
        widget.quizTitle.contains('Baseline');
    final isPostTest =
        widget.quizTitle.contains('Post') ||
        widget.quizTitle.contains('Mastery');
    final isPracticeMode = !isPreTest && !isPostTest;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🎉 Quiz Completed!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accuracy >= 80
                    ? const Color(0xFFECFDF5)
                    : Colors.orange.shade50,
                border: Border.all(
                  color: accuracy >= 80
                      ? const Color(0xFF10B981)
                      : Colors.orange,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '$accuracy%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accuracy >= 80
                        ? const Color(0xFF10B981)
                        : Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Accuracy',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF1E5E2F),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+$growthPercent% Growth',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5E2F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _resultStat(
              'Total Time Spent',
              '$m:${s.toString().padLeft(2, '0')}',
            ),
            _resultStat('Final Accuracy', '$accuracy%'),
            _resultStat(
              'Anti-Cheat Deductions',
              '-${_antiCheatViolations * _xpPenaltyPerViolation} XP',
              color: Colors.red,
            ),
            _resultStat('Total XP Earned', '+$xpEarned XP'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Divider(color: Colors.grey.shade200),
            ),
            _resultStat('Level', 'Lv${prog.level} — ${prog.levelTitle}'),
            _resultStat('Total XP', '${prog.xp} XP'),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommended Focus Topics',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: focusTopics
                    .map(
                      (topic) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (_antiCheatViolations > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$_antiCheatViolations anti-cheat violation(s) were recorded.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5E2F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    // Trigger appropriate callback based on quiz type
                    if (isPreTest && widget.onPreTestComplete != null) {
                      widget.onPreTestComplete!();
                    } else if (isPracticeMode &&
                        widget.onPracticeModeComplete != null) {
                      widget.onPracticeModeComplete!();
                    }
                  },
                  child: Text(
                    isPreTest
                        ? 'Start Warmup / Practice'
                        : isPracticeMode
                        ? 'Take Post-Test'
                        : 'Back to Hub',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to Reviewer',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════

  String get _elapsedTime {
    if (_startTime == null) return '0:00';
    final sec = DateTime.now().difference(_startTime!).inSeconds;
    return '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}';
  }

  Color _typeColor(String t) => switch (t) {
    'mcq' => const Color(0xFF3B82F6),
    'sequence' => const Color(0xFFF59E0B),
    'recall' => const Color(0xFF8B5CF6),
    'fill_blank' => const Color(0xFF06B6D4),
    _ => const Color(0xFF64748B),
  };

  String _typeLabel(String t) => switch (t) {
    'mcq' => 'Multiple Choice',
    'sequence' => 'Sequence Order',
    'recall' => 'Active Recall',
    'fill_blank' => 'Fill in the Blanks',
    _ => 'Question',
  };

  VoidCallback? _buttonAction() {
    if (_antiCheatTerminated) return null;
    final q = _questions[_currentIndex];
    final t = q['type'] as String;

    if (t == 'mcq' && !_answered) {
      return _selectedOption == null ? null : _submitAnswer;
    }
    if (t == 'sequence') {
      return _sequenceChecked
          ? _nextQuestion
          : (_allSlotsFilled ? _checkSequenceOrder : null);
    }
    if (t == 'recall') {
      if (_recallChecked) return _nextQuestion;
      return _recallController.text.trim().isNotEmpty
          ? _checkRecallAnswer
          : null;
    }
    if (t == 'fill_blank') {
      if (_fillBlankChecked) return _nextQuestion;
      return _fillBlankController.text.trim().isNotEmpty
          ? _checkFillBlankAnswer
          : null;
    }
    if (_currentIndex < _questions.length - 1) return _nextQuestion;
    return _finishQuiz;
  }

  String _buttonText() {
    if (_antiCheatTerminated) {
      return 'Terminated';
    }
    final q = _questions[_currentIndex];
    final t = q['type'] as String;

    if (t == 'mcq' && !_answered) {
      return 'Submit Answer';
    }
    if (t == 'sequence') {
      return _sequenceChecked ? 'Next Question ➔' : 'Check Order';
    }
    if (t == 'recall') {
      return _recallChecked ? 'Next Question ➔' : 'Check Model Answer';
    }
    if (t == 'fill_blank') {
      return _fillBlankChecked ? 'Next Question ➔' : 'Check Answer';
    }
    if (_currentIndex < _questions.length - 1) {
      return 'Next Question ➔';
    }
    return 'View Quiz Result';
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];
    final type = q['type'] as String;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF0F4F1), const Color(0xFFE2EFE7)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E5E2F),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.quizTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (_antiCheatViolations > 0)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 14,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_antiCheatViolations/$_maxViolations',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ── Top progress bar ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentIndex + 1} of ${_questions.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$_pointsEarned pts',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E5E2F),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _elapsedTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                              if (_antiCheatViolations > 0) ...[
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.red.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 12,
                                        color: Colors.red.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$_antiCheatViolations/$_maxViolations',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_currentIndex + 1) / _questions.length,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1E5E2F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable question area ────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor(type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _typeLabel(type),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _typeColor(type),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Question card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(
                                0xFF1E5E2F,
                              ).withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16,
                                spreadRadius: 2,
                                color: Colors.black.withValues(alpha: 0.06),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            q['question'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Type-specific content
                        if (type == 'mcq') _buildMcq(q),
                        if (type == 'sequence') _buildSequence(q),
                        if (type == 'recall') _buildRecall(q),
                        if (type == 'fill_blank') _buildFillBlank(q),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // ── Gamification bar ────────────────────────────────────
                _gamBar(),

                const SizedBox(height: 12),

                // ── Action button ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E5E2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _buttonAction(),
                      child: Text(
                        _buttonText(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  MCQ WIDGETS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMcq(Map<String, dynamic> q) {
    final options = q['options'] as List;
    return Column(
      children: List.generate(options.length, (i) {
        final text = options[i] as String;
        final sel = _selectedOption == i;
        final correct = q['correctIndex'] == i;

        Color border = const Color(0xFFE2E8F0);
        Color bg = Colors.white;
        if (_answered) {
          if (correct) {
            bg = const Color(0xFFECFDF5);
            border = const Color(0xFF10B981);
          } else if (sel) {
            bg = const Color(0xFFFEF2F2);
            border = const Color(0xFFEF4444);
          }
        } else if (sel) {
          bg = const Color(0xFFEFF6FF);
          border = const Color(0xFF3B82F6);
        }

        return GestureDetector(
          onTap: _answered ? null : () => setState(() => _selectedOption = i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: border,
                width: sel || (_answered && correct) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: sel ? border : const Color(0xFFF1F5F9),
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sel ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SEQUENCE ORDER WIDGETS
  // ═══════════════════════════════════════════════════════════════════

  void _resetSequenceOrder(int slotCount) {
    setState(() {
      final allItems = <String>[
        ..._targetSlots.whereType<String>(),
        ..._availableItems,
      ];
      _targetSlots = List<String?>.filled(slotCount, null);
      _availableItems = allItems;
      _selectedAvailableIndex = null;
      _sequenceChecked = false;
    });
  }

  Widget _buildSequence(Map<String, dynamic> q) {
    final int slotCount = (q['sequence'] as List).length;
    final int filled = _targetSlots.where((s) => s != null).length;
    const double columnHeight = 380.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Two-column side-by-side layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Available Items
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: columnHeight,
                    child: _availableItems.isEmpty
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Center(
                              child: Text(
                                'All items assigned',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(_availableItems.length, (
                                i,
                              ) {
                                final isSel = _selectedAvailableIndex == i;
                                return GestureDetector(
                                  onTap: _sequenceChecked
                                      ? null
                                      : () => setState(
                                          () => _selectedAvailableIndex = isSel
                                              ? null
                                              : i,
                                        ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? const Color(0xFF1E5E2F)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSel
                                            ? const Color(0xFF1E5E2F)
                                            : Colors.grey.shade300,
                                        width: isSel ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      _availableItems[i],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSel
                                            ? Colors.white
                                            : const Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right column: Target Order slots
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Order ($filled/$slotCount)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: columnHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          slotCount,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _slot(i, q),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Bottom action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _sequenceChecked
                    ? null
                    : () => _resetSequenceOrder(slotCount),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey.shade700,
                  disabledBackgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _allSlotsFilled && !_sequenceChecked
                    ? _checkSequenceOrder
                    : null,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: Text(
                  _sequenceChecked ? 'Confirmed' : 'Confirm Sequence',
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _slot(int index, Map<String, dynamic> q) {
    final filled = _targetSlots[index] != null;
    final correct =
        _sequenceChecked &&
        _targetSlots[index] == (q['sequence'] as List)[index];
    final wrong = _sequenceChecked && _targetSlots[index] != null && !correct;

    return GestureDetector(
      onTap: _sequenceChecked
          ? null
          : () {
              if (filled) {
                setState(() {
                  _availableItems.add(_targetSlots[index]!);
                  _targetSlots[index] = null;
                });
              } else if (_selectedAvailableIndex != null) {
                setState(() {
                  _targetSlots[index] =
                      _availableItems[_selectedAvailableIndex!];
                  _availableItems.removeAt(_selectedAvailableIndex!);
                  _selectedAvailableIndex = null;
                });
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: filled
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: correct
                      ? const Color(0xFFECFDF5)
                      : wrong
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: correct
                        ? const Color(0xFF10B981)
                        : wrong
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF3B82F6),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: correct
                            ? const Color(0xFF10B981)
                            : wrong
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _targetSlots[index]!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (wrong)
                      const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                    if (correct)
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Color(0xFF10B981),
                      ),
                  ],
                ),
              )
            : CustomPaint(
                painter: _DashedBorderPainter(
                  color: Colors.grey.shade400,
                  borderRadius: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Tap to assign',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ACTIVE RECALL WIDGETS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildRecall(Map<String, dynamic> q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _recallController,
          enabled: !_recallChecked,
          maxLines: 5,
          minLines: 3,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF1E5E2F), width: 2),
            ),
          ),
        ),
        if (_recallChecked) ...[const SizedBox(height: 16), _recallFeedback(q)],
      ],
    );
  }

  Widget _buildFillBlank(Map<String, dynamic> q) {
    final accepted = List<String>.from(q['acceptedAnswers'] as List);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _fillBlankController,
          enabled: !_fillBlankChecked,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: q['promptHint'] as String? ?? 'Type the missing term...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF1E5E2F), width: 2),
            ),
          ),
        ),
        if (_fillBlankChecked) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _fillBlankCorrect
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _fillBlankCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _fillBlankCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: _fillBlankCorrect
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _fillBlankCorrect
                        ? 'Correct! ${accepted.first} is the missing term.'
                        : 'Incorrect. The correct answer is ${accepted.first}.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _fillBlankCorrect
                          ? const Color(0xFF065F46)
                          : const Color(0xFF7F1D1D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _recallFeedback(Map<String, dynamic> q) {
    final Color matchCol = _similarityScore >= 80
        ? const Color(0xFF10B981)
        : _similarityScore >= 60
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);
    final String verdict = _similarityScore >= 80
        ? 'Excellent'
        : _similarityScore >= 60
        ? 'Good'
        : 'Needs Work';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Color(0xFF8B5CF6),
              ),
              SizedBox(width: 6),
              Text(
                'AI Feedback',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Similarity badge + verdict
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: matchCol.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: matchCol.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.speed_rounded,
                      size: 16,
                      color: Color(0xFF1E5E2F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_similarityScore.round()}% Match',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: matchCol,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                verdict,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: matchCol,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Key concepts
          Text(
            'Key Concepts',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ..._keyConceptResults.map((r) {
            final ok = r['status'] == 'found';
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 16,
                    color: ok ? const Color(0xFF10B981) : Colors.red.shade400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r['concept']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: ok
                            ? const Color(0xFF1E293B)
                            : Colors.grey.shade500,
                        decoration: ok ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Model answer
          const SizedBox(height: 14),
          Text(
            'Model Answer',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              q['modelAnswer'] as String,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  GAMIFICATION BAR
  // ═══════════════════════════════════════════════════════════════════

  Widget _gamBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _miniStat(
            Icons.bolt_rounded,
            '$_pointsEarned XP',
            const Color(0xFF1E5E2F),
          ),
          Container(width: 1, height: 20, color: Colors.grey.shade200),
          _miniStat(Icons.timer_rounded, _elapsedTime, const Color(0xFF64748B)),
          Container(width: 1, height: 20, color: Colors.grey.shade200),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _antiCheatViolations == 0
                  ? Colors.grey.shade100
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _antiCheatViolations == 0
                    ? Colors.grey.shade300
                    : Colors.red.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 12,
                  color: _antiCheatViolations == 0
                      ? const Color(0xFF64748B)
                      : Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_antiCheatViolations/$_maxViolations',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _antiCheatViolations == 0
                        ? const Color(0xFF64748B)
                        : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SMALL REUSABLE HELPERS
  // ═══════════════════════════════════════════════════════════════════

  Widget _miniStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _penaltyRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _resultStat(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
