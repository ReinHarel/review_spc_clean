import 'dart:math';
import 'package:flutter/material.dart';

class QuizHubView extends StatefulWidget {
  final int initialModeIndex;
  final String? subjectTitle;
  final String? subjectCode;

  const QuizHubView({
    super.key,
    this.initialModeIndex = 0,
    this.subjectTitle,
    this.subjectCode,
  });

  @override
  State<QuizHubView> createState() => _QuizHubViewState();
}

class _QuizHubViewState extends State<QuizHubView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late int _selectedMode;

  // Anti-Cheat & Gamification Stats
  int _antiCheatViolations = 0;
  bool _isAntiCheatDialogShowing = false;
  int _xpEarned = 120;
  final int _streakDays = 5;
  final double _accuracy = 85.0;

  // Multiple Choice State
  final int _currentQuestionIndex = 5;
  int? _selectedAnswerIndex;

  final List<Map<String, dynamic>> _mcQuestions = [
    {
      'question':
          'Which of the following data structures operates on a Last-In, First-Out (LIFO) basis?',
      'options': ['A. Queue', 'B. Stack', 'C. Linked List', 'D. Binary Tree'],
      'correct': 1,
    }
  ];

  // Active Recall State
  final TextEditingController _recallController = TextEditingController();
  bool _showRecallAnswer = false;

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
      'answer': 'Assets = Liabilities + Owner\'s Equity'
    },
  ];

  // Sequential Drag & Drop Interactive Matching State
  final List<String> _dragAndDropChoices = [
    '3. Trial Balance',
    '1. Journalizing',
    '2. Posting to Ledger',
    '4. Financial Statements',
  ];

  final Map<int, String?> _targetSlots = {
    1: null,
    2: null,
    3: null,
    4: null,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedMode = widget.initialModeIndex;

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _showBack = _flipAnimation.value >= 0.5;
        });
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flipController.dispose();
    _recallController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (!_isAntiCheatDialogShowing) {
        setState(() {
          _antiCheatViolations++;
          _xpEarned = max(0, _xpEarned - 20);
          _isAntiCheatDialogShowing = true;
        });
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
              'App switching detected! Violation #$_antiCheatViolations.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              '⚠️ Penalty Applied: -20 XP deducted!\nPlease stay inside the app.',
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.subjectCode ?? 'Gamified Review Modules',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTopModeSelector(),

          // Anti-Cheat Status & Timer Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility_outlined,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      _antiCheatViolations > 0
                          ? 'Anti-Cheat: $_antiCheatViolations Warning(s)'
                          : 'Anti-Cheat Active',
                      style: TextStyle(
                        fontSize: 11,
                        color: _antiCheatViolations > 0
                            ? Colors.red
                            : Colors.grey.shade600,
                        fontWeight: _antiCheatViolations > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (_selectedMode == 0 || _selectedMode == 1 || _selectedMode == 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14, color: Colors.black87),
                        SizedBox(width: 4),
                        Text('0:21',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildActiveModeBody(),
            ),
          ),

          _buildBottomStatsBar(),
        ],
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
      default:
        return SingleChildScrollView(child: _buildMultipleChoiceView());
    }
  }

  Widget _buildTopModeSelector() {
    final modes = [
      'Multiple Choice',
      'Active Recall',
      'Swipe True/False',
      'Flashcards',
      'Sequential Drag&Drop'
    ];
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: modes.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedMode == index;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(modes[index]),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              selectedColor: const Color(0xFF1E5E2F),
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onSelected: (bool selected) {
                setState(() {
                  _selectedMode = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  // --- 0. Multiple Choice View ---
  // --- 0. Multiple Choice View (Front-End Demo Friendly) ---
  Widget _buildMultipleChoiceView() {
    final q = _mcQuestions[0];
    final correctIndex = q['correct'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Question $_currentQuestionIndex of 10',
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _currentQuestionIndex / 10,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF1E5E2F),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            q['question'],
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(q['options'].length, (index) {
          final isSelected = _selectedAnswerIndex == index;
          final isCorrectOption = index == correctIndex;
          final hasAnswered = _selectedAnswerIndex != null;

          Color bgColor = Colors.white;
          Color borderColor = Colors.grey.shade300;
          Color textColor = Colors.black87;
          Widget? trailingIcon;

          if (hasAnswered) {
            if (isCorrectOption) {
              // Always highlight the correct answer in GREEN once an answer is chosen
              bgColor = const Color(0xFFE8F5E9);
              borderColor = const Color(0xFF1E5E2F);
              textColor = const Color(0xFF1E5E2F);
              trailingIcon = const Icon(Icons.check_circle, color: Color(0xFF1E5E2F));
            } else if (isSelected && !isCorrectOption) {
              // Highlight the wrong chosen answer in RED
              bgColor = const Color(0xFFFFEBEE);
              borderColor = Colors.red;
              textColor = Colors.red.shade900;
              trailingIcon = const Icon(Icons.cancel, color: Colors.red);
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedAnswerIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: (isSelected || (hasAnswered && isCorrectOption)) ? 2 : 1,
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
                          fontWeight: (isSelected || (hasAnswered && isCorrectOption))
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
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedAnswerIndex == correctIndex
                      ? Icons.lightbulb_outline
                      : Icons.info_outline,
                  color: _selectedAnswerIndex == correctIndex
                      ? const Color(0xFF1E5E2F)
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
                          ? const Color(0xFF1E5E2F)
                          : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ],
    );
  }
  // --- 1. Active Recall View ---
  Widget _buildActiveRecallView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Question 3 of 10', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF1E5E2F),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Text(
            'Explain the difference between Debt and Equity Financing in 1-2 sentences.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _recallController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Type your explanation here...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5E2F),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _showRecallAnswer = !_showRecallAnswer;
              });
            },
            child: Text(_showRecallAnswer ? 'Hide Model Answer' : 'Check Model Answer', style: const TextStyle(color: Colors.white)),
          ),
        ),
        if (_showRecallAnswer) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E5E2F)),
            ),
            child: const Text(
              'Model Answer: Debt involves borrowing money to be repaid with interest, while Equity involves raising capital by selling shares of ownership.',
              style: TextStyle(fontSize: 13, color: Color(0xFF1E5E2F)),
            ),
          )
        ]
      ],
    );
  }

  // --- 2. SWIPE TRUE/FALSE WITH TILTED ROTATION & HAND ICON (Matches Image 3) ---
  Widget _buildSwipeTrueFalseView() {
    final rotationAngle = (_swipeCardOffset / 300) * (pi / 12);

    return Column(
      children: [
        const Text('Question 6 of 10', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF1E5E2F),
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
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hand Gesture Tap Icon
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 40,
                      color: Color(0xFF1E5E2F),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _swipeQuestions[_swipeCardIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '👈 Drag Left for False | Drag Right for True 👉',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => _triggerNextSwipeCard(),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('FALSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => _triggerNextSwipeCard(),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('TRUE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        )
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
                        ? const LinearGradient(
                            colors: [Color(0xFF0F381B), Color(0xFF1E5E2F)],
                          )
                        : const LinearGradient(
                            colors: [Colors.white, Color(0xFFF1F5F9)],
                          ),
                    border: Border.all(
                      color: _showBack ? Colors.green.shade800 : Colors.grey.shade300,
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                                child: const Text('ANSWER', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 16),
                              Text(_flashcardsData[0]['answer']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(10)),
                              child: const Text('QUESTION', style: TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 16),
                            Text(_flashcardsData[0]['question']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            const SizedBox(height: 16),
                            const Text('Tap card to flip', style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => setState(() => _reviewCards++),
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Review Again', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1E5E2F), Color(0xFF15803D)]),
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
                  }),
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Know It!', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Remaining', '$_remainingCards', Colors.black87),
              _buildStatItem('Known', '$_knownCards', const Color(0xFF16A34A)),
              _buildStatItem('Review', '$_reviewCards', const Color(0xFFEA580C)),
            ],
          ),
        )
      ],
    );
  }

  // --- 4. REAL INTERACTIVE DRAG & DROP WITH RE-ADDABLE SLOTS (Matches Images 1 & 2) ---
  Widget _buildSequentialDragAndDropView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Question 6 of 10', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF1E5E2F),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Procedural Challenge',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          'Sequence the steps of the Accounting Cycle correctly:',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Draggable choices
            Expanded(
              child: Column(
                children: _dragAndDropChoices.map((item) {
                  final isAlreadyPlaced = _targetSlots.containsValue(item);

                  if (isAlreadyPlaced) {
                    // Empty spacer when dragged/placed so position is maintained
                    return const SizedBox(height: 64);
                  }

                  return Draggable<String>(
                    data: item,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E5E2F), width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                        ),
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildChoiceCard(item),
                    ),
                    child: _buildChoiceCard(item),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(width: 16),

            // Right Column: Interactive Drop Target Slots 1, 2, 3, 4
            Expanded(
              child: Column(
                children: [1, 2, 3, 4].map((slotNum) {
                  final placedValue = _targetSlots[slotNum];

                  return DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        _targetSlots[slotNum] = details.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;

                      return Container(
                        width: double.infinity,
                        height: 52,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: placedValue != null
                              ? const Color(0xFFE8F5E9)
                              : (isHovered ? const Color(0xFFF1F8F3) : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: placedValue != null
                                ? const Color(0xFF1E5E2F)
                                : (isHovered ? const Color(0xFF1E5E2F) : Colors.grey.shade300),
                            width: placedValue != null || isHovered ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: placedValue != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        placedValue,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF1E5E2F),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Removes from slot and automatically returns to left choices list
                                        setState(() {
                                          _targetSlots[slotNum] = null;
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(Icons.cancel, size: 18, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                )
                              : Text(
                                  '$slotNum',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Action Buttons: Reset & Confirm
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () {
                  // Clears all slots, restoring all items to left list
                  setState(() {
                    _targetSlots.updateAll((key, value) => null);
                  });
                },
                child: Text('Reset', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF1E5E2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: const Text('Confirm Sequence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildChoiceCard(String item) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          )
        ],
      ),
      child: Center(
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // --- Dynamic Bottom Stats Bar ---
  Widget _buildBottomStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_streakDays Days', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('Streak', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('+$_xpEarned XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('Earned', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          if (_selectedMode != 3)
            Row(
              children: [
                const Icon(Icons.center_focus_strong_rounded, color: Colors.green, size: 20),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_accuracy.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const Text('Accuracy', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}