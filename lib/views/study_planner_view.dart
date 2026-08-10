import 'package:flutter/material.dart';

class StudyPlannerView extends StatefulWidget {
  const StudyPlannerView({super.key});

  @override
  State<StudyPlannerView> createState() => _StudyPlannerViewState();
}

class _StudyPlannerViewState extends State<StudyPlannerView> {
  int _selectedDayIndex = 0; // 0: Mon, 1: Tue...
  
  final List<Map<String, String>> _days = [
    {'day': 'Mon', 'date': '10'},
    {'day': 'Tue', 'date': '11'},
    {'day': 'Wed', 'date': '12'},
    {'day': 'Thu', 'date': '13'},
    {'day': 'Fri', 'date': '14'},
    {'day': 'Sat', 'date': '15'},
    {'day': 'Sun', 'date': '16'},
  ];

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Review Biology Chapter 1 Notes',
      'subject': 'Biology 101',
      'time': '09:00 AM - 10:30 AM',
      'isDone': true,
      'priority': 'High',
      'color': Colors.lightGreen,
    },
    {
      'title': 'Practice Dart & Flutter Coding Exercises',
      'subject': 'Computer Prog 2',
      'time': '01:00 PM - 03:00 PM',
      'isDone': false,
      'priority': 'Medium',
      'color': Colors.blue,
    },
    {
      'title': 'Read Philippine History Chapters 3 & 4',
      'subject': 'Phil History',
      'time': '04:00 PM - 05:30 PM',
      'isDone': false,
      'priority': 'Low',
      'color': Colors.orange,
    },
  ];

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Study Task 📝',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  hintText: 'e.g. Solve 10 Math Problems',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        hintText: 'e.g. Math 101',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Time Slot',
                        hintText: 'e.g. 2:00 PM',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added to schedule!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5E2F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFocusTimer(String taskTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.timer_rounded, color: Color(0xFF1E5E2F)),
            SizedBox(width: 8),
            Text('Focus Session', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              taskTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '25:00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E5E2F)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Pomodoro Method (25m Study / 5m Break)', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pomodoro timer started! Stay focused 🎯')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5E2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Start Timer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t['isDone'] as bool).length;
    final totalCount = _tasks.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Study Planner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: Colors.amberAccent),
            tooltip: 'AI Auto-Schedule',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI is optimizing your weekly study timetable... ✨')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskModal,
        backgroundColor: const Color(0xFF1E5E2F),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. PROGRESS HEADER CARD & STREAK
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Today\'s Goal Progress 🎯',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$completedCount of $totalCount tasks completed',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange.shade300),
                              ),
                              child: Row(
                                children: const [
                                  Text('🔥 ', style: TextStyle(fontSize: 13)),
                                  Text(
                                    '5 Day Streak',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E5E2F)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. AI SMART ADVICE CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFE8F5E9), const Color(0xFFE0F2FE)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: Color(0xFF1E5E2F), size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 11, color: Color(0xFF1E293B)),
                              children: const [
                                TextSpan(text: 'AI Study Insight: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: 'Your peak focus time is 09:00 AM. Great job starting Biology early!'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. WEEKLY SCHEDULE DAY STRIP
                  const Text(
                    'Weekly Schedule',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedDayIndex == index;
                        final dayData = _days[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 58,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF1E5E2F) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1E5E2F) : Colors.black.withValues(alpha: 0.08),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1E5E2F).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayData['day']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dayData['date']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
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

                  // 4. TASKS HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks for ${_days[_selectedDayIndex]['day']}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        '${_tasks.length} Items',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 5. TASK LIST CARDS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final bool isDone = task['isDone'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Checkbox
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tasks[index]['isDone'] = !isDone;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isDone ? const Color(0xFF1E5E2F) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDone ? const Color(0xFF1E5E2F) : Colors.grey.shade400,
                                    width: 1.8,
                                  ),
                                ),
                                child: isDone
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? Colors.grey : const Color(0xFF1E293B),
                                      decoration: isDone ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      // Subject Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          task['subject'],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E5E2F),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Time Slot
                                      Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade500),
                                      const SizedBox(width: 3),
                                      Text(
                                        task['time'],
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Focus Session Button & Delete
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF1E5E2F), size: 22),
                                  tooltip: 'Start Focus Timer',
                                  onPressed: () => _showFocusTimer(task['title']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _tasks.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}