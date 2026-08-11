import 'package:flutter/material.dart';

class QuizHubView extends StatefulWidget {
  const QuizHubView({super.key});

  @override
  State<QuizHubView> createState() => _QuizHubViewState();
}

class _QuizHubViewState extends State<QuizHubView> {
  int _selectedMode = 0; // 0: MC, 1: Active Recall, 2: Swipe T/F, 3: Flashcards, 4: Drag&Drop
  bool _isFlipped = false;

  // Flashcards Counter State
  int _remainingCards = 4;
  int _knownCards = 0;
  int _reviewCards = 0;

  // Swipe State
  double _swipeOffset = 0.0;
  bool _isDragging = false;

  // Active Recall State
  final TextEditingController _recallController = TextEditingController();

  // Sequential Drag & Drop State (Left Options & Right Placed Slots)
  final List<String> _initialOptions = [
    '3. Trial Balance',
    '1. Journalizing',
    '4. Financial Statements',
    '2. Posting to Ledger',
  ];

  // Stores items placed in target slots 1, 2, 3, 4 (null if empty)
  List<String?> _placedItems = [null, null, '4. Financial Statements', null];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D3B18), Color(0xFF1E5E2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Gamified Review Modules',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          // Mode Selector Bar
          _buildModeSelector(),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(
                  children: [
                    // --- CONDITIONALLY RENDER HEADER BASED ON MODE ---
                    if (_selectedMode != 3) ...[
                      // Quiz Modes: Show Timer & Progress Bar Header
                      _buildHeaderStatus(),
                    ] else ...[
                      // Flashcards Mode: Header badge lang (No timer/progress bar)
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0, right: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('Anti-Cheat Active', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              SizedBox(width: 12),
                              Icon(Icons.cloud_done_outlined, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('Cloud Sync', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Main Dynamic Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          children: [
                            _buildSelectedModule(),

                            const SizedBox(height: 16),

                            // Display appropriate stats per module
                            if (_selectedMode == 3)
                              _buildFlashcardsStats()
                            else
                              _buildQuizSessionStats(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TOP MODE SELECTOR ---
  Widget _buildModeSelector() {
    final modes = [
      'Multiple Choice',
      'Active Recall',
      'Swipe True/False',
      'Flashcards',
      'Sequential Drag&Drop'
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(modes.length, (index) {
            final isSelected = _selectedMode == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => setState(() {
                  _selectedMode = index;
                  _isFlipped = false;
                }),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E5E2F) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        modes[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- HEADER FOR QUIZ MODES (Timer + Progress Bar) ---
  Widget _buildHeaderStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Anti-Cheat Active', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  SizedBox(width: 12),
                  Icon(Icons.cloud_done_outlined, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Cloud Sync', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E5E2F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1E5E2F)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 13, color: Color(0xFF1E5E2F)),
                    SizedBox(width: 4),
                    Text('0:21', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Question 6 of 10', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedModule() {
    switch (_selectedMode) {
      case 0: return _buildMultipleChoice();
      case 1: return _buildActiveRecall();
      case 2: return _buildSwipeTrueFalse();
      case 3: return _buildFlashcards();
      case 4: return _buildDragDrop();
      default: return _buildMultipleChoice();
    }
  }

  // --- 1. MULTIPLE CHOICE ---
  Widget _buildMultipleChoice() {
    return Column(
      children: [
        _buildQuestionCard("Which of the following data structures operates on a Last-In, First-Out (LIFO) basis?"),
        const SizedBox(height: 16),
        _buildOptionButton("A. Queue"),
        _buildOptionButton("B. Stack"),
        _buildOptionButton("C. Linked List"),
        _buildOptionButton("D. Binary Tree"),
      ],
    );
  }

  // --- 2. ACTIVE RECALL ---
  Widget _buildActiveRecall() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildBadge('Fill in Blank', Colors.grey.shade200, Colors.black87),
            const SizedBox(width: 8),
            _buildBadge('Medium', Colors.amber.shade100, Colors.amber.shade900),
          ],
        ),
        const SizedBox(height: 10),
        const Text('Active Recall', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F))),
        const Text('Complete the statement by typing the missing keyword:', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 12),
        _buildQuestionCard('"A [ ______ ] is a data structure that follows LIFO ordering."'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb, size: 16, color: Colors.amber),
              SizedBox(width: 8),
              Text('Hint: Starts with letter "S", 5 letters', style: TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _recallController,
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 20),
        _buildGradientButton('Submit Answer', () {}),
      ],
    );
  }

  // --- 3. SWIPE TRUE/FALSE ---
  Widget _buildSwipeTrueFalse() {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _swipeOffset += details.delta.dx;
              _isDragging = true;
            });
          },
          onPanEnd: (details) {
            setState(() {
              _isDragging = false;
              _swipeOffset = 0.0;
            });
          },
          child: AnimatedContainer(
            duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_swipeOffset, 0, 0)..rotateZ(_swipeOffset / 1000),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2)],
            ),
            child: Column(
              children: [
                const Icon(Icons.touch_app, size: 40, color: Color(0xFF1E5E2F)),
                const SizedBox(height: 16),
                const Text('Depreciation is a non-cash expense.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('👈 Drag Left for False | Drag Right for True 👉', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
                label: const Text('FALSE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                label: const Text('TRUE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 4. FLASHCARDS ---
  Widget _buildFlashcards() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isFlipped = !_isFlipped),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 220),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(
                  _isFlipped ? 'ANSWER' : 'QUESTION',
                  _isFlipped ? const Color(0xFFC8E6C9) : Colors.grey.shade200,
                  _isFlipped ? const Color(0xFF1E5E2F) : Colors.black87,
                ),
                const SizedBox(height: 24),
                Text(
                  _isFlipped
                      ? 'Assets = Liabilities + Owner\'s Equity'
                      : 'What is the accounting equation?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.autorenew, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Tap to flip', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    if (_remainingCards > 0) _remainingCards--;
                    _reviewCards++;
                    _isFlipped = false;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.orange, size: 18),
                label: const Text('Review Again', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D3B18),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    if (_remainingCards > 0) _remainingCards--;
                    _knownCards++;
                    _isFlipped = false;
                  });
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                label: const Text('Know It!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 5. SEQUENTIAL DRAG & DROP (2-COLUMN MATCHING UI) ---
  Widget _buildDragDrop() {
    final unplacedOptions = _initialOptions
        .where((option) => !_placedItems.contains(option))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Procedural Challenge',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sequence the steps of the Accounting Cycle correctly:',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 20),

        // TWO-COLUMN DRAG & DROP LAYOUT
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT COLUMN: Options
            Expanded(
              flex: 2,
              child: Column(
                children: unplacedOptions.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Draggable<String>(
                      data: option,
                      feedback: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF1E5E2F), width: 1.5),
                          ),
                          child: Text(
                            option,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _buildOptionChip(option),
                      ),
                      child: _buildOptionChip(option),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(width: 20),

            // RIGHT COLUMN: Target Slots (1, 2, 3, 4)
            Expanded(
              flex: 3,
              child: Column(
                children: List.generate(4, (index) {
                  final placedItem = _placedItems[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DragTarget<String>(
                      onAcceptWithDetails: (details) {
                        setState(() {
                          _placedItems[index] = details.data;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isFilled = placedItem != null;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFilled ? const Color(0xFFE8F5E9) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isFilled
                                  ? const Color(0xFF1E5E2F)
                                  : (candidateData.isNotEmpty ? const Color(0xFF1E5E2F) : Colors.grey.shade300),
                              width: isFilled ? 1.5 : 1.0,
                            ),
                          ),
                          child: isFilled
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      placedItem,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E5E2F),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _placedItems[index] = null;
                                        });
                                      },
                                      child: const Icon(Icons.cancel, size: 16, color: Colors.grey),
                                    ),
                                  ],
                                )
                              : Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // BOTTOM BUTTONS (Reset & Confirm Sequence)
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _placedItems = [null, null, null, null];
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5E2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text(
                  'Confirm Sequence',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- FLASHCARDS STATS (Remaining, Known, Review) ---
  Widget _buildFlashcardsStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Session Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat('$_remainingCards', 'Remaining', Colors.black87),
              _buildSimpleStat('$_knownCards', 'Known', Colors.green),
              _buildSimpleStat('$_reviewCards', 'Review', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  // --- QUIZ STATS (Streak, XP, Accuracy) ---
  Widget _buildQuizSessionStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.local_fire_department, '5 Days', 'Streak', Colors.orange),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          _buildStatItem(Icons.bolt, '+120 XP', 'Earned', Colors.amber.shade700),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          _buildStatItem(Icons.center_focus_strong, '85%', 'Accuracy', const Color(0xFF1E5E2F)),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildOptionChip(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildQuestionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.4)),
    );
  }

  Widget _buildOptionButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textCol)),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onPressed, {IconData? icon}) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E5E2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 6)],
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}