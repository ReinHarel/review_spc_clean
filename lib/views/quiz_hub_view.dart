import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/game_progress.dart';
import 'quiz_take_view.dart';

class QuizHubView extends StatefulWidget {
  final int initialModeIndex;
  final String? subjectTitle;
  final String? subjectCode;

  const QuizHubView({
    super.key,
    this.initialModeIndex = 6,
    this.subjectTitle,
    this.subjectCode,
  });

  @override
  State<QuizHubView> createState() => _QuizHubViewState();
}

class _QuizHubViewState extends State<QuizHubView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late int _selectedMode;
  int _lastAssessmentMode = 6;
  int _lastPracticeMode = 0;

  // ── Theme-driven styling (follows global dark mode) ───────────────
  bool get _eliteMode => Theme.of(context).brightness == Brightness.dark;

  Color get _accent =>
      _eliteMode ? const Color(0xFF2ECC71) : const Color(0xFF1E5E2F);
  Color get _bgTop => Theme.of(context).scaffoldBackgroundColor;
  Color get _bgBottom =>
      _eliteMode ? const Color(0xFF18241D) : const Color(0xFFE2EFE7);
  Color get _cardFill => _eliteMode
      ? Theme.of(context).cardColor
      : Colors.white.withValues(alpha: 0.62);
  Color get _cardBorder => _eliteMode
      ? const Color(0xFF2ECC71).withValues(alpha: 0.35)
      : const Color(0xFF1E5E2F).withValues(alpha: 0.15);
  Color get _textPrimary =>
      _eliteMode ? const Color(0xFFECEFF1) : const Color(0xFF0F172A);
  Color get _textSecondary =>
      _eliteMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get _inputFill => _eliteMode
      ? Theme.of(context).cardColor.withValues(alpha: 0.55)
      : Colors.white.withValues(alpha: 0.75);
  Color get _glassBorder => _eliteMode
      ? const Color(0xFF2ECC71).withValues(alpha: 0.18)
      : Colors.white.withValues(alpha: 0.5);

  Widget _glassWrap({
    required Widget child,
    double radius = 24,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    Color? fill,
    Color? border,
    bool glow = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: fill ?? _cardFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: border ?? _glassBorder),
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }

  // Anti-Cheat & Gamification Stats
  int _antiCheatViolations = 0;
  bool _isAntiCheatDialogShowing = false;
  bool _antiCheatTerminated = false;
  static const int _maxAntiCheatViolations = 3;
  static const int _antiCheatPenalty = 20;

  GameProgressStore get _store => GameProgressStore.instance;

  int _customItemCount = 10;
  String _timerSpeed = 'Standard';
  final List<String> _availableQuizTopics = [
    'Algorithms',
    'Data Structures',
    'Operating Systems',
    'Networking',
    'Databases',
  ];
  final List<String> _selectedQuizTopics = ['Algorithms', 'Data Structures'];

  // Multiple Choice State
  final int _currentQuestionIndex = 5;
  int? _selectedAnswerIndex;

  final List<Map<String, dynamic>> _mcQuestions = [
    {
      'question':
          'Which of the following data structures operates on a Last-In, First-Out (LIFO) basis?',
      'options': ['A. Queue', 'B. Stack', 'C. Linked List', 'D. Binary Tree'],
      'correct': 1,
    },
  ];

  // Active Recall State
  final TextEditingController _recallController = TextEditingController();
  bool _showRecallAnswer = false;
  bool _recallXpAwarded = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  late final AnimationController _micPulseController;
  late final Animation<double> _micPulseAnimation;

  static const String _recallModelAnswer =
      'Debt involves borrowing money to be repaid with interest, while Equity involves raising capital by selling shares of ownership. '
      'Debt creates an obligation to repay, while equity gives investors ownership and control rights.';
  static const List<String> _recallKeyConcepts = [
    'borrowing',
    'interest',
    'shares',
    'ownership',
    'obligation',
    'capital',
    'control',
    'repay',
  ];

  // Swipe True/False Animation State
  int _swipeCardIndex = 0;
  double _swipeCardOffset = 0.0;

  final List<String> _swipeQuestions = [
    'Depreciation is a non-cash expense.',
    'Does Goodwill appear on the Income Statement?',
  ];

  // Flashcards & Flip Animation State
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _showBack = false;

  int _remainingCards = 2;
  int _knownCards = 1;
  int _reviewCards = 1;

  final List<Map<String, String>> _flashcardsData = [
    {
      'question': 'What is the accounting equation?',
      'answer': 'Assets = Liabilities + Owner\'s Equity',
    },
  ];

  // Sequence Order (dynamic steps) State
  final List<String> _sequenceSteps = [
    '1. Journalizing',
    '2. Posting to Ledger',
    '3. Trial Balance',
    '4. Financial Statements',
    '5. Adjusting Entries',
  ];
  List<String> _sequenceSlots = [];
  List<String> _sequenceAvailable = [];
  bool _sequenceConfirmed = false;

  // Fill in the Blanks State
  final TextEditingController _fillBlankController = TextEditingController();
  int _fillBlankIndex = 0;
  bool _fillBlankSubmitted = false;
  bool _fillBlankCorrect = false;

  final List<Map<String, String>> _fillBlankQuestions = [
    {'question': 'Assets = _____ + Equity.', 'answer': 'Liabilities'},
    {'question': '_____ = Liabilities + Owner\'s Equity.', 'answer': 'Assets'},
    {
      'question': '_____ are the resources owned by a business.',
      'answer': 'Assets',
    },
    {
      'question': 'Amounts owed to outside parties are called _____.',
      'answer': 'Liabilities',
    },
    {
      'question': 'The accounting equation must always remain in _____.',
      'answer': 'Balance',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedMode = widget.initialModeIndex;
    if (_selectedMode >= 6) {
      _lastAssessmentMode = _selectedMode;
    } else {
      _lastPracticeMode = _selectedMode;
    }

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _micPulseAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _micPulseController, curve: Curves.easeInOut),
    );

    _flipAnimation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() {
            _showBack = _flipAnimation.value >= 0.5;
          });
        });

    _initSequence();
  }

  void _initSequence() {
    _sequenceSlots = <String>[];
    _sequenceAvailable = List<String>.from(_sequenceSteps)..shuffle();
    _sequenceConfirmed = false;
  }

  bool get _allSequenceSlotsFilled => _sequenceAvailable.isEmpty;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flipController.dispose();
    _micPulseController.dispose();
    _speechToText.stop();
    _recallController.dispose();
    _fillBlankController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_isAntiCheatDialogShowing || _antiCheatTerminated) return;

      setState(() {
        _antiCheatViolations++;
        final currentXp = _store.progress.xp;
        _store.addXp(-min(_antiCheatPenalty, currentXp));
      });

      if (_antiCheatViolations >= _maxAntiCheatViolations) {
        _antiCheatTerminated = true;
        _showAntiCheatTerminationDialog();
      } else {
        _isAntiCheatDialogShowing = true;
        _showAntiCheatWarningDialog();
      }
    }
  }

  void _showAntiCheatWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEBEFEA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text(
                  'Anti-Cheat Alert!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'App switching detected! Violation #$_antiCheatViolations of $_maxAntiCheatViolations.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              '⚠️ Penalty Applied: -$_antiCheatPenalty XP deducted!\n$_maxAntiCheatViolations violations auto-terminate this quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  _isAntiCheatDialogShowing = false;
                  Navigator.pop(context);
                },
                child: const Text(
                  'I Understand',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      _isAntiCheatDialogShowing = false;
    });
  }

  void _showAntiCheatTerminationDialog() {
    final int penalty = _antiCheatViolations * _antiCheatPenalty;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEBEFEA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        title: Row(
          children: [
            Icon(Icons.gpp_bad_rounded, color: Colors.red.shade700, size: 28),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Quiz Terminated',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
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
              child: const Text(
                'Quiz Terminated Due to Anti-Cheat Violations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You exceeded the maximum of $_maxAntiCheatViolations tab-switching violations.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.remove_circle_outline,
                  size: 18,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                const Text(
                  'XP Deduction',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C2822),
                  ),
                ),
                const Spacer(),
                Text(
                  '-$penalty XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Icon(Icons.grade_outlined, size: 18, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Quiz Grade',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C2822),
                  ),
                ),
                Spacer(),
                Text(
                  'Marked as Incomplete',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5E2F),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Back to Reviewer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlipCard() {
    if (_flipController.isAnimating) return;
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final progress = _store.progress;
        final streakDays = max(1, progress.level + 1);
        final accuracy = progress.quizzesCompleted > 0
            ? ((progress.accuracyMasterCount / progress.quizzesCompleted) * 100)
                  .clamp(0.0, 100.0)
            : 0.0;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_bgTop, _bgBottom],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: _eliteMode
                    ? const Color(0xFF121B16).withValues(alpha: 0.85)
                    : const Color(0xFF1E5E2F),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  widget.subjectCode ?? 'Gamified Review Modules',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  _buildTopModeSelector(),

                  // Anti-Cheat Status & Timer Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_antiCheatViolations > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
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
                                  'Anti-Cheat $_antiCheatViolations/$_maxAntiCheatViolations',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 14,
                                color: _textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Anti-Cheat Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        if (_selectedMode == 0 ||
                            _selectedMode == 1 ||
                            _selectedMode == 2)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _eliteMode
                                  ? const Color(
                                      0xFF2F3E37,
                                    ).withValues(alpha: 0.5)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 14,
                                  color: _textPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '0:21',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: _buildActiveModeBodyCard(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  _buildBottomStatsBar(progress, streakDays, accuracy),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveModeBodyCard() {
    return _glassWrap(
      radius: 24,
      padding: const EdgeInsets.all(24),
      border: _cardBorder,
      glow: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedMode),
          child: _buildActiveModeBody(),
        ),
      ),
    );
  }

  Widget _buildActiveModeBody() {
    switch (_selectedMode) {
      case 0:
        return SingleChildScrollView(child: _buildMultipleChoiceView());
      case 1:
        return SingleChildScrollView(child: _buildActiveRecallView());
      case 2:
        return SingleChildScrollView(child: _buildSwipeTrueFalseView());
      case 3:
        return SingleChildScrollView(child: _build3DFlashcardView());
      case 4:
        return SingleChildScrollView(child: _buildSequentialDragAndDropView());
      case 5:
        return _buildFillInTheBlanksView();
      case 6:
        return _buildAssessmentCard(
          title: 'Pre-Test (Baseline Assessment)',
          subtitle:
              'Gauge your current understanding before the module begins.',
          badge: '+0% Growth',
          highlight: 'Starts your study baseline',
          isPreTest: true,
        );
      case 7:
        return _buildAssessmentCard(
          title: 'Post-Test (Mastery Assessment)',
          subtitle: 'Measure improvement after completing the learning track.',
          badge: '+45% Growth',
          highlight: 'Mastery check after practice',
          isPreTest: false,
        );
      case 8:
        return _buildCustomQuizCard();
      default:
        return SingleChildScrollView(child: _buildMultipleChoiceView());
    }
  }

  Widget _buildAssessmentCard({
    required String title,
    required String subtitle,
    required String badge,
    required String highlight,
    required bool isPreTest,
  }) {
    return _glassWrap(
      padding: const EdgeInsets.all(24),
      radius: 24,
      border: _cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _eliteMode
                  ? const Color(0xFFF1C40F).withValues(alpha: 0.15)
                  : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(999),
              border: _eliteMode
                  ? Border.all(
                      color: const Color(0xFFF1C40F).withValues(alpha: 0.3),
                    )
                  : null,
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: _accent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 13, color: _textSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _glassBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.insights_rounded, color: _accent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    highlight,
                    style: TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _eliteMode
                    ? const Color(0xFF121B16)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizTakeView(
                      quizTitle: 'Assessment Quiz',
                      subjectCode: 'Baseline',
                      onPreTestComplete: isPreTest
                          ? () => setState(() => _selectedMode = 0)
                          : null,
                      onPracticeModeComplete: !isPreTest
                          ? () => setState(() => _selectedMode = 6)
                          : null,
                    ),
                  ),
                );
              },
              child: Text(
                title.contains('Pre') ? 'Begin Baseline' : 'Begin Mastery Quiz',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomQuizCard() {
    return _glassWrap(
      padding: const EdgeInsets.all(24),
      radius: 24,
      border: _cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Quiz Setup',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Build a focused review session for your weakest topics.',
            style: TextStyle(fontSize: 13, color: _textSecondary),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Topics',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedQuizTopics
                      .map(
                        (topic) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _eliteMode
                                ? const Color(
                                    0xFFF1C40F,
                                  ).withValues(alpha: 0.15)
                                : const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(999),
                            border: _eliteMode
                                ? Border.all(
                                    color: const Color(
                                      0xFFF1C40F,
                                    ).withValues(alpha: 0.3),
                                  )
                                : null,
                          ),
                          child: Text(
                            topic,
                            style: TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _eliteMode
                    ? const Color(0xFF121B16)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showCustomQuizDialog,
              child: const Text(
                'Customize & Launch',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomQuizDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final List<String> selectedTopics = List<String>.from(
          _selectedQuizTopics,
        );
        int itemCount = _customItemCount;
        String timerSpeed = _timerSpeed;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Custom Quiz Setup'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Item Count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2822),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [5, 10, 15, 20].map((count) {
                        final selected = itemCount == count;
                        return ChoiceChip(
                          label: Text('$count'),
                          selected: selected,
                          selectedColor: const Color(0xFF1E5E2F),
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) =>
                              setStateDialog(() => itemCount = count),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Timer Speed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2822),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Relaxed', 'Standard', 'Hardcore'].map((
                        speed,
                      ) {
                        final selected = timerSpeed == speed;
                        return ChoiceChip(
                          label: Text(speed),
                          selected: selected,
                          selectedColor: const Color(0xFF1E5E2F),
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) =>
                              setStateDialog(() => timerSpeed = speed),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Specific Topic Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2822),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableQuizTopics.map((topic) {
                        final selected = selectedTopics.contains(topic);
                        return FilterChip(
                          label: Text(topic),
                          selected: selected,
                          selectedColor: const Color(0xFF1E5E2F),
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            setStateDialog(() {
                              if (selected) {
                                selectedTopics.remove(topic);
                              } else {
                                selectedTopics.add(topic);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5E2F),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _customItemCount = itemCount;
                      _timerSpeed = timerSpeed;
                      _selectedQuizTopics
                        ..clear()
                        ..addAll(selectedTopics);
                    });
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizTakeView(
                          quizTitle: 'Custom Quiz • $timerSpeed',
                          subjectCode: selectedTopics.join(', '),
                          onPracticeModeComplete: () =>
                              setState(() => _selectedMode = 6),
                        ),
                      ),
                    );
                  },
                  child: const Text('Launch Quiz'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTopModeSelector() {
    final isAssessment = _selectedMode >= 6;

    final modes = isAssessment
        ? const [
            {'name': 'Pre-Test', 'index': 6},
            {'name': 'Post-Test', 'index': 7},
            {'name': 'Custom Quiz', 'index': 8},
          ]
        : const [
            {'name': 'Multiple Choice', 'index': 0},
            {'name': 'Active Recall', 'index': 1},
            {'name': 'Swipe True/False', 'index': 2},
            {'name': 'Flashcards', 'index': 3},
            {'name': 'Sequence Order', 'index': 4},
            {'name': 'Fill in the Blanks', 'index': 5},
          ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Compact Segmented Button for Category Switching ─────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
          child: SizedBox(
            height: 36,
            width: double.infinity,
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment<int>(
                  value: 0,
                  label: Text(
                    'Assessments',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.assignment_outlined, size: 16),
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text(
                    'Practice Modes',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.school_outlined, size: 16),
                ),
              ],
              selected: {isAssessment ? 0 : 1},
              onSelectionChanged: (newSelection) {
                final val = newSelection.first;
                setState(() {
                  if (val == 0) {
                    _selectedMode = _lastAssessmentMode;
                  } else {
                    _selectedMode = _lastPracticeMode;
                  }
                });
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return _accent;
                  }
                  return _eliteMode
                      ? const Color(0xFF16202E).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.7);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return _eliteMode ? const Color(0xFF121B16) : Colors.white;
                  }
                  return _textSecondary;
                }),
                side: WidgetStateProperty.all(
                  BorderSide(color: _cardBorder, width: 1),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Single Horizontal Scrollable ChoiceChips Row ────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            children: [
              for (final mode in modes)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(mode['name'] as String),
                    selected: _selectedMode == (mode['index'] as int),
                    labelStyle: TextStyle(
                      color: _selectedMode == (mode['index'] as int)
                          ? (_eliteMode
                                ? const Color(0xFF121B16)
                                : Colors.white)
                          : _textPrimary,
                      fontWeight: _selectedMode == (mode['index'] as int)
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 12,
                    ),
                    selectedColor: _accent,
                    backgroundColor: _eliteMode
                        ? const Color(0xFF16202E).withValues(alpha: 0.8)
                        : Colors.white,
                    side: BorderSide(
                      color: _selectedMode == (mode['index'] as int)
                          ? _accent
                          : (_eliteMode
                                ? const Color(0xFF2F3E37)
                                : Colors.grey.shade300),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          final idx = mode['index'] as int;
                          _selectedMode = idx;
                          if (isAssessment) {
                            _lastAssessmentMode = idx;
                          } else {
                            _lastPracticeMode = idx;
                          }
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFillInTheBlanksView() {
    final total = _fillBlankQuestions.length;
    final current = _fillBlankIndex + 1;
    final questionData = _fillBlankQuestions[_fillBlankIndex];
    final question = questionData['question']!;
    final answer = questionData['answer']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Practice: Fill in the Blanks',
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
            Text(
              'Question $current of $total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: _accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: _eliteMode
                ? const Color(0xFF2F3E37)
                : Colors.grey.shade200,
            color: _accent,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        _glassWrap(
          padding: const EdgeInsets.all(20),
          radius: 16,
          border: _cardBorder,
          child: Text(
            question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _glassWrap(
          padding: EdgeInsets.zero,
          radius: 12,
          fill: _inputFill.withValues(alpha: 0.6),
          child: TextField(
            controller: _fillBlankController,
            enabled: !_fillBlankSubmitted,
            style: TextStyle(color: _textPrimary, fontSize: 14),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Type the missing term...',
              hintStyle: TextStyle(
                color: _eliteMode
                    ? const Color(0xFF94A3B8)
                    : Colors.grey.shade400,
              ),
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _fillBlankSubmitted
                ? (_fillBlankCorrect
                      ? (_eliteMode
                            ? const Color(0xFF10B981).withValues(alpha: 0.14)
                            : const Color(0xFFE8F5E9))
                      : (_eliteMode
                            ? const Color(0xFFEF4444).withValues(alpha: 0.14)
                            : const Color(0xFFFFEBEE)))
                : _inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _fillBlankSubmitted
                  ? (_fillBlankCorrect
                        ? (_eliteMode
                              ? const Color(0xFF10B981)
                              : const Color(0xFF1E5E2F))
                        : Colors.red)
                  : _glassBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _fillBlankSubmitted
                    ? (_fillBlankCorrect ? Icons.check_circle : Icons.cancel)
                    : Icons.lightbulb_outline,
                color: _fillBlankSubmitted
                    ? (_fillBlankCorrect
                          ? (_eliteMode
                                ? const Color(0xFF10B981)
                                : const Color(0xFF1E5E2F))
                          : Colors.red)
                    : _accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _fillBlankSubmitted
                      ? (_fillBlankCorrect
                            ? 'Correct! You earned 10 XP.'
                            : 'Incorrect. The correct answer is $answer.')
                      : 'Use the missing term that completes the statement.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _fillBlankSubmitted
                        ? (_fillBlankCorrect
                              ? (_eliteMode
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF1E5E2F))
                              : Colors.red.shade900)
                        : _textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_fillBlankSubmitted) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _eliteMode
                    ? const Color(0xFF121B16)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _nextFillBlankQuestion,
              child: Text(
                _fillBlankIndex < total - 1 ? 'Next Question' : 'Start Over',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _eliteMode
                    ? const Color(0xFF121B16)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _fillBlankController.text.trim().isEmpty
                  ? null
                  : _checkFillBlankAnswer,
              child: const Text(
                'Check Answer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _checkFillBlankAnswer() {
    final q = _fillBlankQuestions[_fillBlankIndex];
    final answer = q['answer']!;
    final isCorrect =
        _fillBlankController.text.trim().toLowerCase() == answer.toLowerCase();
    setState(() {
      _fillBlankCorrect = isCorrect;
      _fillBlankSubmitted = true;
    });
    if (isCorrect) _store.addXp(10);
  }

  void _nextFillBlankQuestion() {
    setState(() {
      _fillBlankController.clear();
      _fillBlankSubmitted = false;
      _fillBlankCorrect = false;
      _fillBlankIndex = (_fillBlankIndex + 1) % _fillBlankQuestions.length;
    });
  }

  // --- 0. Multiple Choice View ---
  // --- 0. Multiple Choice View (Front-End Demo Friendly) ---
  Widget _buildMultipleChoiceView() {
    final q = _mcQuestions[0];
    final correctIndex = q['correct'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question $_currentQuestionIndex of 10',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _currentQuestionIndex / 10,
            backgroundColor: _eliteMode
                ? const Color(0xFF2F3E37)
                : Colors.grey.shade200,
            color: _accent,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        _glassWrap(
          padding: const EdgeInsets.all(20),
          radius: 16,
          border: _cardBorder,
          child: Text(
            q['question'],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(q['options'].length, (index) {
          final isSelected = _selectedAnswerIndex == index;
          final isCorrectOption = index == correctIndex;
          final hasAnswered = _selectedAnswerIndex != null;

          Color bgColor = _cardFill;
          Color borderColor = _eliteMode
              ? const Color(0xFF2F3E37)
              : Colors.grey.shade300;
          Color textColor = _textPrimary;
          Widget? trailingIcon;

          if (hasAnswered) {
            if (isCorrectOption) {
              // Always highlight the correct answer in GREEN once an answer is chosen
              bgColor = _eliteMode
                  ? const Color(0xFF10B981).withValues(alpha: 0.14)
                  : const Color(0xFFE8F5E9);
              borderColor = _eliteMode
                  ? const Color(0xFF10B981)
                  : const Color(0xFF1E5E2F);
              textColor = _eliteMode
                  ? const Color(0xFF10B981)
                  : const Color(0xFF1E5E2F);
              trailingIcon = Icon(
                Icons.check_circle,
                color: _eliteMode
                    ? const Color(0xFF10B981)
                    : const Color(0xFF1E5E2F),
              );
            } else if (isSelected && !isCorrectOption) {
              // Highlight the wrong chosen answer in RED
              bgColor = _eliteMode
                  ? const Color(0xFFEF4444).withValues(alpha: 0.14)
                  : const Color(0xFFFFEBEE);
              borderColor = Colors.red;
              textColor = Colors.red.shade900;
              trailingIcon = const Icon(Icons.cancel, color: Colors.red);
            }
          } else if (isSelected) {
            bgColor = _eliteMode
                ? const Color(0xFFF1C40F).withValues(alpha: 0.2)
                : const Color(0xFFE8F5E9);
            borderColor = _accent;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                if (_selectedAnswerIndex != null) return;
                setState(() {
                  _selectedAnswerIndex = index;
                  if (index == correctIndex) _store.addXp(10);
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: (isSelected || (hasAnswered && isCorrectOption))
                        ? 2
                        : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        q['options'][index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              (isSelected || (hasAnswered && isCorrectOption))
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ),
                    trailingIcon ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        }),
        // Optional UI Hint message for Front-End Demo feedback
        if (_selectedAnswerIndex != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _selectedAnswerIndex == correctIndex
                  ? (_eliteMode
                        ? const Color(0xFF10B981).withValues(alpha: 0.14)
                        : const Color(0xFFE8F5E9))
                  : (_eliteMode
                        ? const Color(0xFFEF4444).withValues(alpha: 0.14)
                        : const Color(0xFFFFEBEE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedAnswerIndex == correctIndex
                      ? Icons.lightbulb_outline
                      : Icons.info_outline,
                  color: _selectedAnswerIndex == correctIndex
                      ? _accent
                      : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedAnswerIndex == correctIndex
                        ? 'Correct! Stacks use LIFO (Last-In, First-Out).'
                        : 'Incorrect! The correct answer is B. Stack.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedAnswerIndex == correctIndex
                          ? _accent
                          : Colors.red.shade900,
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

  Future<void> _toggleRecallMic() async {
    if (_isListening) {
      await _speechToText.stop();
      _micPulseController.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speechToText.initialize();
    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition is not available on this device.'),
        ),
      );
      return;
    }

    await _speechToText.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          _recallController.text = result.recognizedWords;
          _recallController.selection = TextSelection.fromPosition(
            TextPosition(offset: _recallController.text.length),
          );
        });
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      ),
    );

    _micPulseController.repeat(reverse: true);
    setState(() => _isListening = true);
  }

  // --- 1. Active Recall View ---
  double _hubSimilarity(String userText, String modelText) {
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

  List<Map<String, String>> _hubConceptResults(
    String userText,
    List<String> concepts,
  ) {
    return concepts.map((c) {
      final found = userText.toLowerCase().contains(c.toLowerCase());
      return {'concept': c, 'status': found ? 'found' : 'missing'};
    }).toList();
  }

  Color _similarityColor(double similarity) {
    if (similarity >= 80) return const Color(0xFF10B981);
    if (similarity >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Widget _buildActiveRecallView() {
    final answer = _recallController.text;
    final similarity = _hubSimilarity(answer, _recallModelAnswer);
    final conceptResults = _hubConceptResults(answer, _recallKeyConcepts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question 3 of 10',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.3,
            backgroundColor: _eliteMode
                ? const Color(0xFF2F3E37)
                : Colors.grey.shade200,
            color: _accent,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        _glassWrap(
          padding: const EdgeInsets.all(20),
          radius: 16,
          border: _cardBorder,
          child: Text(
            'Explain the difference between Debt and Equity Financing in 1-2 sentences.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _glassWrap(
          padding: EdgeInsets.zero,
          radius: 12,
          fill: _inputFill.withValues(alpha: 0.6),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              TextField(
                controller: _recallController,
                maxLines: 4,
                minLines: 3,
                style: TextStyle(color: _textPrimary, fontSize: 14),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Type or speak your explanation here...',
                  hintStyle: TextStyle(
                    color: _eliteMode
                        ? const Color(0xFF94A3B8)
                        : Colors.grey.shade400,
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 56,
                    top: 16,
                    bottom: 48,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: AnimatedBuilder(
                  animation: _micPulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _micPulseAnimation.value : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? const Color(0xFFDC2626)
                              : _cardFill,
                          border: Border.all(
                            color: _isListening
                                ? Colors.red
                                : _eliteMode
                                ? const Color(0xFFF1C40F)
                                : const Color(0xFF1E5E2F),
                            width: 1.5,
                          ),
                          boxShadow: _isListening
                              ? [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: IconButton(
                          onPressed: _toggleRecallMic,
                          tooltip: _isListening
                              ? 'Stop recording'
                              : 'Speak answer',
                          icon: Icon(
                            _isListening
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            color: _isListening ? Colors.white : _accent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_isListening) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              AnimatedBuilder(
                animation: _micPulseAnimation,
                builder: (context, child) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(
                          alpha: 0.3 + _micPulseAnimation.value * 0.3,
                        ),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Recording… Speak now',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _eliteMode
                  ? const Color(0xFF121B16)
                  : Colors.white,
              disabledBackgroundColor: _accent.withValues(alpha: 0.35),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: answer.trim().isEmpty
                ? null
                : () {
                    setState(() {
                      _showRecallAnswer = !_showRecallAnswer;
                      if (_showRecallAnswer && !_recallXpAwarded) {
                        final sim = _hubSimilarity(answer, _recallModelAnswer);
                        if (sim >= 60.0) {
                          _store.addXp(15);
                          _recallXpAwarded = true;
                        }
                      }
                    });
                  },
            child: Text(
              _showRecallAnswer ? 'Hide Model Answer' : 'Check Model Answer',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (_showRecallAnswer) ...[
          const SizedBox(height: 16),
          _glassWrap(
            padding: const EdgeInsets.all(16),
            radius: 16,
            fill: _eliteMode
                ? const Color(0xFF7C3AED).withValues(alpha: 0.14)
                : const Color(0xFFF5F3FF).withValues(alpha: 0.9),
            border: _eliteMode
                ? const Color(0xFFA78BFA).withValues(alpha: 0.4)
                : const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.smart_toy_rounded,
                      color: Color(0xFF7C3AED),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SPC Tutor Evaluation',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2822),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Similarity match badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _similarityColor(
                          similarity,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _similarityColor(
                            similarity,
                          ).withValues(alpha: 0.3),
                        ),
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
                            '${similarity.round()}% Match',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _similarityColor(similarity),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      similarity >= 80
                          ? 'Excellent'
                          : similarity >= 60
                          ? 'Good'
                          : 'Needs Work',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _similarityColor(similarity),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Key concepts breakdown
                Text(
                  'Key Concepts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...conceptResults.map((r) {
                  final ok = r['status'] == 'found';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          ok
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 16,
                          color: ok
                              ? const Color(0xFF10B981)
                              : Colors.red.shade400,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r['concept']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: ok ? _textPrimary : _textSecondary,
                              decoration: ok
                                  ? null
                                  : TextDecoration.lineThrough,
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
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _eliteMode
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : const Color(0xFFE8F5E9).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _recallModelAnswer,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: _textPrimary,
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

  // --- 2. SWIPE TRUE/FALSE WITH TILTED ROTATION & HAND ICON (Matches Image 3) ---
  Widget _buildSwipeTrueFalseView() {
    final rotationAngle = (_swipeCardOffset / 300) * (pi / 12);

    return Column(
      children: [
        Text(
          'Question 6 of 10',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.6,
            backgroundColor: _eliteMode
                ? const Color(0xFF2F3E37)
                : Colors.grey.shade200,
            color: _accent,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 24),

        // Interactive Tilted Drag Card
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _swipeCardOffset += details.delta.dx;
            });
          },
          onPanEnd: (details) {
            if (_swipeCardOffset > 100) {
              // Swiped Right -> TRUE
              _triggerNextSwipeCard();
            } else if (_swipeCardOffset < -100) {
              // Swiped Left -> FALSE
              _triggerNextSwipeCard();
            } else {
              // Snap back to center
              setState(() {
                _swipeCardOffset = 0.0;
              });
            }
          },
          child: Transform.translate(
            offset: Offset(_swipeCardOffset, 0),
            child: Transform.rotate(
              angle: rotationAngle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: _cardFill,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _eliteMode
                        ? const Color(0xFFF1C40F).withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hand Gesture Tap Icon
                    Icon(Icons.touch_app_rounded, size: 40, color: _accent),
                    const SizedBox(height: 16),
                    Text(
                      _swipeQuestions[_swipeCardIndex],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '👈 Drag Left for False | Drag Right for True 👉',
                      style: TextStyle(
                        fontSize: 11,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // False and True Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF5350),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _triggerNextSwipeCard(),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text(
                  'FALSE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: _eliteMode
                      ? const Color(0xFF121B16)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _triggerNextSwipeCard(),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'TRUE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _triggerNextSwipeCard() {
    setState(() {
      _swipeCardOffset = 0.0;
      _swipeCardIndex = (_swipeCardIndex + 1) % _swipeQuestions.length;
    });
  }

  // --- 3. Flashcards View ---
  Widget _build3DFlashcardView() {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _toggleFlipCard,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value * pi;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: 240,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: _showBack
                        ? (_eliteMode
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF16202E),
                                    Color(0xFF121B16),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF0F381B),
                                    Color(0xFF1E5E2F),
                                  ],
                                ))
                        : (_eliteMode
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF1C2822),
                                    Color(0xFF0F172A),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [Colors.white, Color(0xFFF1F5F9)],
                                )),
                    border: Border.all(
                      color: _showBack
                          ? (_eliteMode
                                ? const Color(0xFFF1C40F)
                                : Colors.green.shade800)
                          : (_eliteMode
                                ? const Color(0xFFF1C40F).withValues(alpha: 0.3)
                                : Colors.grey.shade300),
                    ),
                  ),
                  child: _showBack
                      ? Transform(
                          transform: Matrix4.identity()..rotateY(pi),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'ANSWER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _flashcardsData[0]['answer']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _eliteMode
                                    ? const Color(
                                        0xFFF1C40F,
                                      ).withValues(alpha: 0.2)
                                    : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'QUESTION',
                                style: TextStyle(
                                  color: _eliteMode
                                      ? const Color(0xFFF1C40F)
                                      : const Color(0xFF475569),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _flashcardsData[0]['question']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tap card to flip',
                              style: TextStyle(
                                fontSize: 11,
                                color: _textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFFFF7ED),
                  foregroundColor: const Color(0xFFEA580C),
                  side: const BorderSide(color: Color(0xFFFDBA74)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => setState(() => _reviewCards++),
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text(
                  'Review Again',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E5E2F), Color(0xFF15803D)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => setState(() {
                    _knownCards++;
                    if (_remainingCards > 0) _remainingCards--;
                    _store.addXp(5);
                  }),
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text(
                    'Know It!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _glassWrap(
          padding: const EdgeInsets.all(16),
          radius: 16,
          border: _cardBorder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Remaining', '$_remainingCards', _textPrimary),
              _buildStatItem(
                'Known',
                '$_knownCards',
                _eliteMode ? const Color(0xFFF1C40F) : const Color(0xFF16A34A),
              ),
              _buildStatItem(
                'Review',
                '$_reviewCards',
                const Color(0xFFEA580C),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. SEQUENCE ORDER (dynamic slots, dashed borders, tap-to-assign) ---
  Widget _buildSequentialDragAndDropView() {
    final int slotCount = _sequenceSteps.length;
    final int filled = _sequenceSlots.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question 6 of 10',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.6,
            backgroundColor: _eliteMode
                ? const Color(0xFF2F3E37)
                : Colors.grey.shade200,
            color: _accent,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sequence Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap an item to add it to the target order, then drag to reorder:',
          style: TextStyle(fontSize: 13, color: _textSecondary),
        ),
        const SizedBox(height: 18),

        // ── Available items (tap to select) ─────────────────────────
        if (_sequenceAvailable.isNotEmpty) ...[
          Text(
            'Available Items  $filled / $slotCount placed',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _eliteMode
                  ? Colors.white.withValues(alpha: 0.87)
                  : const Color(0xFF1C2822),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_sequenceAvailable.length, (i) {
                  final item = _sequenceAvailable[i];
                  return GestureDetector(
                    onTap: _sequenceConfirmed
                        ? null
                        : () => setState(() {
                            _sequenceAvailable.removeAt(i);
                            _sequenceSlots.add(item);
                          }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                  decoration: BoxDecoration(
                    color: _eliteMode
                        ? const Color(0xFF16202E).withValues(alpha: 0.8)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _eliteMode
                          ? const Color(0xFF2F3E37)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ),
);
              }),
            ),
          ),
        ),
        const SizedBox(height: 18),
        ],

        // ── Target Order (tap to remove, drag to reorder) ────────────────
        Text(
          'Target Order  ($filled / $slotCount placed)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _eliteMode
                ? Colors.white.withValues(alpha: 0.87)
                : const Color(0xFF1C2822),
          ),
        ),
        if (filled >= 2 && !_sequenceConfirmed) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.drag_indicator_rounded,
                size: 14,
                color: _textSecondary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Drag to reorder • tap a card to remove',
                  style: TextStyle(fontSize: 11, color: _textSecondary),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: _sequenceSlots.isEmpty
              ? SizedBox(
                  height: 160,
                  child: CustomPaint(
                    painter: _HubDashedBorderPainter(
                      color: _eliteMode
                          ? const Color(0xFF64748B)
                          : Colors.grey.shade400,
                      borderRadius: 12,
                    ),
                    child: SizedBox.expand(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Tap items above to build your sequence',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: _sequenceSlots.length,
                  onReorderItem: _onSequenceReorder,
                  proxyDecorator: (child, index, animation) => AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) => Material(
                      color: Colors.transparent,
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                  ),
                  itemBuilder: (context, i) {
                    final value = _sequenceSlots[i];
                    return Container(
                      key: ValueKey('target_slot_${i}_${value.hashCode}'),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _buildSequenceSlot(i),
                      ),
                    );
                  },
                ),
        ),

        // ── Feedback after confirm ──────────────────────────────────
        if (_sequenceConfirmed) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _sequenceCorrect
                  ? (_eliteMode
                        ? const Color(0xFF10B981).withValues(alpha: 0.14)
                        : const Color(0xFFE8F5E9))
                  : (_eliteMode
                        ? const Color(0xFFEF4444).withValues(alpha: 0.14)
                        : const Color(0xFFFFEBEE)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _sequenceCorrect ? Icons.check_circle : Icons.cancel,
                  color: _sequenceCorrect
                      ? const Color(0xFF10B981)
                      : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _sequenceCorrect
                        ? 'Correct order! +15 XP earned.'
                        : 'Incorrect order. Review the steps and try again.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _sequenceCorrect
                          ? const Color(0xFF10B981)
                          : _eliteMode
                          ? Colors.redAccent[100]
                          : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // ── Action Buttons: Reset & Confirm ─────────────────────────
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: _eliteMode ? Colors.white : Colors.grey.shade300,
                  ),
                  disabledForegroundColor: Colors.white54,
                ),
                onPressed: _sequenceConfirmed ? null : _resetSequence,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: _sequenceConfirmed
                        ? Colors.white54
                        : (_eliteMode
                              ? Colors.white.withValues(alpha: 0.87)
                              : Colors.grey.shade700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: const Color(0xFF0B1220),
                  disabledBackgroundColor: const Color(0xFF23352B),
                  disabledForegroundColor: Colors.white54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _sequenceConfirmed
                    ? null
                    : (_allSequenceSlotsFilled ? _confirmSequence : null),
                child: Text(
                  _sequenceConfirmed ? 'Completed' : 'Confirm Sequence',
                  style: TextStyle(
                    color: (!_sequenceConfirmed && _allSequenceSlotsFilled)
                        ? const Color(0xFF0B1220)
                        : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool get _sequenceCorrect {
    if (_sequenceSlots.length != _sequenceSteps.length) return false;
    for (var i = 0; i < _sequenceSteps.length; i++) {
      if (_sequenceSlots[i] != _sequenceSteps[i]) return false;
    }
    return true;
  }

  void _confirmSequence() {
    setState(() => _sequenceConfirmed = true);
    if (_sequenceCorrect) {
      _store.addXp(15);
    }
  }

  void _onSequenceReorder(int oldIndex, int newIndex) {
    if (_sequenceConfirmed) return;
    setState(() {
      final item = _sequenceSlots.removeAt(oldIndex);
      _sequenceSlots.insert(newIndex, item);
    });
  }

  void _resetSequence() {
    setState(_initSequence);
  }

  Widget _buildSequenceSlot(int index) {
    final item = _sequenceSlots[index];
    final correct = _sequenceConfirmed && item == _sequenceSteps[index];
    final wrong = _sequenceConfirmed && !correct;

    return GestureDetector(
      onTap: _sequenceConfirmed
          ? null
          : () => setState(() {
              _sequenceAvailable.add(item);
              _sequenceSlots.removeAt(index);
            }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: correct
              ? const Color(0xFFD4EFDF)
              : wrong
              ? const Color(0xFFFADBD8)
              : _cardFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: correct
                ? const Color(0xFF145A32)
                : wrong
                ? const Color(0xFF78281F)
                : _accent,
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
                    ? const Color(0xFF145A32)
                    : wrong
                    ? const Color(0xFF78281F)
                    : _accent,
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
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: correct
                      ? const Color(0xFF145A32)
                      : wrong
                      ? const Color(0xFF78281F)
                      : _textPrimary,
                ),
              ),
            ),
            if (wrong)
              const Icon(
                Icons.close_rounded,
                size: 18,
                color: Color(0xFF78281F),
              ),
            if (correct)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Color(0xFF145A32),
              ),
            if (!_sequenceConfirmed)
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    size: 20,
                    color: correct
                        ? const Color(0xFF145A32)
                        : wrong
                        ? const Color(0xFF78281F)
                        : _textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: _textSecondary)),
      ],
    );
  }

  // --- Dynamic Bottom Stats Bar ---
  Widget _buildBottomStatsBar(
    GameProgress progress,
    int streakDays,
    double accuracy,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: _eliteMode
            ? const Color(0xFF121B16).withValues(alpha: 0.85)
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: _eliteMode
                ? const Color(0xFFF1C40F).withValues(alpha: 0.2)
                : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.orange,
                size: 22,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays Days',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Streak',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 22),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '+${progress.xp} XP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Earned',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_selectedMode != 3)
            Row(
              children: [
                Icon(
                  Icons.center_focus_strong_rounded,
                  color: _eliteMode ? const Color(0xFFF1C40F) : Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${accuracy.round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Accuracy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Dashed-border painter for empty Sequence Order slots ─────────────

class _HubDashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _HubDashedBorderPainter({required this.color, this.borderRadius = 12});

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
  bool shouldRepaint(covariant _HubDashedBorderPainter old) =>
      old.color != color;
}
