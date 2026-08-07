import 'package:flutter/material.dart';
import '../core/constants.dart';

class StudyPlannerView extends StatefulWidget {
  const StudyPlannerView({super.key});

  @override
  State<StudyPlannerView> createState() => _StudyPlannerViewState();
}

class _StudyPlannerViewState extends State<StudyPlannerView> {
  int _selectedDayIndex = 0; // 0 = Mon, 1 = Tue, etc.

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Sample Tasks per day
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Review Biology Chapter 1 Notes',
      'subject': 'Biology 101',
      'time': '09:00 AM - 10:30 AM',
      'isDone': true,
      'color': Colors.green,
    },
    {
      'title': 'Practice Dart & Flutter Coding Exercises',
      'subject': 'Computer Prog 2',
      'time': '01:00 PM - 03:00 PM',
      'isDone': false,
      'color': Colors.blue,
    },
    {
      'title': 'Read Philippine History Chapters 3 & 4',
      'subject': 'Phil History',
      'time': '04:00 PM - 05:30 PM',
      'isDone': false,
      'color': Colors.orange,
    },
  ];

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add New Study Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g. Read Chapter 5',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'e.g. Biology',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.spcbaGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add({
                      'title': _taskController.text,
                      'subject': _subjectController.text.isNotEmpty
                          ? _subjectController.text
                          : 'General',
                      'time': 'Scheduled',
                      'isDone': false,
                      'color': Colors.purple,
                    });
                  });
                  _taskController.clear();
                  _subjectController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.spcbaGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.spcbaGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.spcbaGreen.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Goal Progress',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _tasks.isEmpty
                        ? 0
                        : _tasks.where((t) => t['isDone'] as bool).length /
                            _tasks.length,
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.spcbaGreen,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_tasks.where((t) => t['isDone'] as bool).length} of ${_tasks.length} tasks completed',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Weekly Days Bar
            const Text(
              'Weekly Schedule',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedDayIndex == index;
                  return InkWell(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 55,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.spcbaGreen
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.spcbaGreen
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _days[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${index + 10}',
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  isSelected ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Tasks Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks for ${_days[_selectedDayIndex]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_tasks.length} Items',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Task List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final isDone = task['isDone'] as bool;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: AppColors.spcbaGreen,
                      value: isDone,
                      onChanged: (bool? newValue) {
                        setState(() {
                          task['isDone'] = newValue ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isDone ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (task['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task['subject'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: task['color'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task['time'],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}