import 'package:flutter/material.dart';
import '../core/constants.dart';

class QuizHubView extends StatefulWidget {
  const QuizHubView({super.key});

  @override
  State<QuizHubView> createState() => _QuizHubViewState();
}

class _QuizHubViewState extends State<QuizHubView> {
  int _selectedModeIndex = 0; // 0: MC, 1: Active Recall, 2: Swipe T/F, 3: Flashcards, 4: Sequential

  // Swipe Card States
  double _cardOffsetX = 0.0;
  double _cardRotation = 0.0;

  // Flashcard State
  bool _isFlipped = false;
  int _flashcardIndex = 0;

  // Sequential Drag & Drop Data
  final List<String> _sequenceItems = [
    '1. Requirements Analysis',
    '2. System Design',
    '3. Implementation & Coding',
    '4. Testing & Integration',
    '5. Deployment & Maintenance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamified Review Modules'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Subheader Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('Anti-Cheat Active', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(width: 12),
                const Icon(Icons.cloud_done_outlined, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                const Text('Cloud Sync', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Scrollable Mode Switcher (5 Modes)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildModePill('Multiple Choice', 0),
                const SizedBox(width: 8),
                _buildModePill('Active Recall', 1),
                const SizedBox(width: 8),
                _buildModePill('Swipe True/False', 2),
                const SizedBox(width: 8),
                _buildModePill('Flashcards', 3),
                const SizedBox(width: 8),
                _buildModePill('Sequential Drag&Drop', 4),
              ],
            ),
          ),
          const Divider(height: 1),

          // Dynamic Active Mode View
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCurrentModeWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModePill(String title, int index) {
    final isSelected = _selectedModeIndex == index;
    return InkWell(
      onTap: () => setState(() {
        _selectedModeIndex = index;
        _isFlipped = false;
        _cardOffsetX = 0;
        _cardRotation = 0;
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.spcbaGreen : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.spcbaGreen) : null,
        ),
        child: Row(
          children: [
            if (isSelected) const Icon(Icons.check, size: 14, color: Colors.white),
            if (isSelected) const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentModeWidget() {
    switch (_selectedModeIndex) {
      case 0:
        return _buildMultipleChoiceMode();
      case 1:
        return _buildActiveRecallMode();
      case 2:
        return _buildInteractiveSwipeTFMode();
      case 3:
        return _buildFlashcardMode();
      case 4:
        return _buildSequentialDragDropMode();
      default:
        return _buildMultipleChoiceMode();
    }
  }

  // ================= 0. MULTIPLE CHOICE =================
  Widget _buildMultipleChoiceMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Question 3 of 10', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Which of the following data structures operates on a Last-In, First-Out (LIFO) basis?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildOptionTile('A. Queue'),
        _buildOptionTile('B. Stack', isCorrect: true),
        _buildOptionTile('C. Linked List'),
        _buildOptionTile('D. Binary Tree'),
      ],
    );
  }

  Widget _buildOptionTile(String text, {bool isCorrect = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }

  // ================= 1. ACTIVE RECALL =================
  Widget _buildActiveRecallMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: Colors.lightBlue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Recall Prompt', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  'Explain the difference between TCP and UDP in 2 sentences.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Type your explanation here from memory...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.spcbaGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {},
          icon: const Icon(Icons.psychology),
          label: const Text('Check AI Feedback'),
        ),
      ],
    );
  }

  // ================= 2. SWIPE TRUE / FALSE =================
  Widget _buildInteractiveSwipeTFMode() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _cardOffsetX += details.delta.dx;
                  _cardRotation = _cardOffsetX / 300;
                });
              },
              onPanEnd: (details) {
                if (_cardOffsetX > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Swiped TRUE!'), duration: Duration(milliseconds: 500)));
                } else if (_cardOffsetX < -100) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Swiped FALSE!'), duration: Duration(milliseconds: 500)));
                }
                setState(() {
                  _cardOffsetX = 0;
                  _cardRotation = 0;
                });
              },
              child: Transform.translate(
                offset: Offset(_cardOffsetX, 0),
                child: Transform.rotate(
                  angle: _cardRotation,
                  child: Card(
                    elevation: 6,
                    color: _cardOffsetX > 50
                        ? Colors.green.shade50
                        : _cardOffsetX < -50
                            ? Colors.red.shade50
                            : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: double.infinity,
                      height: 280,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _cardOffsetX > 50
                                ? Icons.check_circle_outline
                                : _cardOffsetX < -50
                                    ? Icons.cancel_outlined
                                    : Icons.swipe_rounded,
                            size: 48,
                            color: _cardOffsetX > 50
                                ? Colors.green
                                : _cardOffsetX < -50
                                    ? Colors.red
                                    : AppColors.spcbaGreen,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Depreciation is a non-cash expense.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '👈 Drag Left for False | Drag Right for True 👉',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Answered FALSE'), duration: Duration(milliseconds: 500)));
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('FALSE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Answered TRUE'), duration: Duration(milliseconds: 500)));
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('TRUE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= 3. FLASHCARDS =================
  Widget _buildFlashcardMode() {
    final flashcards = [
      {'q': 'What is Encapsulation?', 'a': 'Wrapping data and methods into a single unit (Class) and restricting direct access to some components.'},
      {'q': 'What is Polymorphism?', 'a': 'The ability of an object to take on many forms (e.g., Method Overriding and Method Overloading).'},
    ];

    final currentCard = flashcards[_flashcardIndex % flashcards.length];

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isFlipped = !_isFlipped),
            child: Card(
              elevation: 4,
              color: _isFlipped ? Colors.amber.shade50 : Colors.indigo.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isFlipped ? 'ANSWER / EXPLANATION' : 'QUESTION (Tap to flip 🔄)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isFlipped ? Colors.amber.shade900 : Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isFlipped ? currentCard['a']! : currentCard['q']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => setState(() {
                  _flashcardIndex++;
                  _isFlipped = false;
                }),
                icon: const Icon(Icons.replay, color: Colors.orange),
                label: const Text('Review Again', style: TextStyle(color: Colors.orange)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.spcbaGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => setState(() {
                  _flashcardIndex++;
                  _isFlipped = false;
                }),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Know It!'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= 4. SEQUENTIAL DRAG & DROP =================
  Widget _buildSequentialDragDropMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Arrange the System Development Life Cycle (SDLC) phases in correct order:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Hold and drag items using the handle on the right ☰', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        Expanded(
          child: ReorderableListView(
           onReorderItem: (int oldIndex, int newIndex) {
            setState(() {
              final item = _sequenceItems.removeAt(oldIndex);
               _sequenceItems.insert(newIndex, item);
            });
          },
            children: [
              for (int index = 0; index < _sequenceItems.length; index++)
                Card(
                  key: ValueKey(_sequenceItems[index]),
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.spcbaGreen,
                      foregroundColor: Colors.white,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_sequenceItems[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.spcbaGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sequence submitted for evaluation!')));
          },
          child: const Text('Submit Sequence', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}