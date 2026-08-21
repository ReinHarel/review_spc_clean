import 'package:flutter/material.dart';
import '../widgets/custom_app_header.dart';

class StudyPlannerView extends StatefulWidget {
  const StudyPlannerView({super.key});

  @override
  State<StudyPlannerView> createState() => _StudyPlannerViewState();
}

class _StudyPlannerViewState extends State<StudyPlannerView> {
  int _selectedDayIndex = 1; // Default to Tue (11)
  String _selectedSubjectFilter = 'All';
  bool _isMonthlyView = false; // Toggle between Week & Month Calendar

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': '📖 Review Biology Chapter 1 Notes',
      'subject': 'Biology 101',
      'time': '09:00 AM - 10:30 AM',
      'isCompleted': true,
      'priority': 'HIGH',
      'color': const Color(0xFFEF4444),
      'day': 11,
    },
    {
      'id': '2',
      'title': '🎨 Practice Dart & Flutter Coding Exercises',
      'subject': 'Computer Prog 2',
      'time': '01:00 PM - 03:00 PM',
      'isCompleted': false,
      'priority': 'MED',
      'color': const Color(0xFFF59E0B),
      'day': 11,
    },
    {
      'id': '3',
      'title': '📝 Read Philippine History Chapters 3 & 4',
      'subject': 'Phil History',
      'time': '04:00 PM - 05:30 PM',
      'isCompleted': false,
      'priority': 'LOW',
      'color': const Color(0xFF3B82F6),
      'day': 11,
    },
  ];

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> _dates = [10, 11, 12, 13, 14, 15, 16];
  final List<String> _subjects = [
    'All',
    'Biology 101',
    'Computer Prog 2',
    'Phil History',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _selectedSubjectFilter == 'All'
        ? _tasks
        : _tasks.where((t) => t['subject'] == _selectedSubjectFilter).toList();

    int completedCount = _tasks.where((t) => t['isCompleted'] == true).length;
    double progressValue = _tasks.isEmpty ? 0 : completedCount / _tasks.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppHeader(
        title: 'Study Planner',
        showBackButton: false,
        actions: [
          IconButton(
            tooltip: 'AI Auto-Schedule',
            icon: const Icon(Icons.auto_awesome, color: Color(0xFFFBBF24)),
            onPressed: _showAiAutoScheduleDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. EXAM COUNTDOWN BANNER
            _buildExamCountdownBanner(),

            const SizedBox(height: 14),

            // 2. TODAY'S GOAL PROGRESS CARD
            _buildGoalProgressCard(completedCount, progressValue),

            const SizedBox(height: 14),

            // 3. AI STUDY INSIGHT BANNER
            _buildAiInsightBanner(),

            const SizedBox(height: 20),

            // 4. CALENDAR HEADER WITH TOGGLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isMonthlyView ? 'Monthly Calendar' : 'Weekly Schedule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isMonthlyView = !_isMonthlyView;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isMonthlyView
                              ? Icons.view_week_rounded
                              : Icons.calendar_month_rounded,
                          size: 14,
                          color: const Color(0xFF1E5E2F),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isMonthlyView ? 'Week View' : 'Month View',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E5E2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 5. CALENDAR VIEW (WEEK STRIP OR MONTH GRID)
            _isMonthlyView ? _buildMonthlyCalendar() : _buildWeeklyCalendar(),

            const SizedBox(height: 18),

            // 6. SUBJECT FILTER CHIPS
            _buildSubjectFilters(),

            const SizedBox(height: 20),

            // 7. TASKS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks for ${_days[_selectedDayIndex]} (${_dates[_selectedDayIndex]})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${filteredTasks.length} Items',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 8. TASK LIST CARDS
            if (filteredTasks.isEmpty)
              _buildEmptyState()
            else
              ...filteredTasks.map((task) => _buildTaskCard(task)),

            const SizedBox(height: 24),

            // 9. BOTTOM SUMMARY STATS BAR (CLICKABLE FOR ANALYTICS)
            GestureDetector(
              onTap: _showDetailedAnalyticsModal,
              child: _buildSummaryStatsBar(),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E5E2F), Color(0xFF0F381B)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5E2F).withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          onPressed: _showAddTaskBottomSheet,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  Widget _buildExamCountdownBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF2F2), Color(0xFFFFF1F2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFDC2626),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '🚨 Upcoming Major Exam',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF991B1B),
                  ),
                ),
                Text(
                  'Biology 101 Midterms in 3 Days!',
                  style: TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Study Session created for Biology Midterms!'),
                ),
              );
            },
            child: const Text(
              'Study Now',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendar() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: List.generate(_days.length, (index) {
          final isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF1E5E2F), Color(0xFF0F381B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isSelected ? null : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFF1E5E2F,
                          ).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  Text(
                    _days[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white70
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dates[index]}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthlyCalendar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'August 2026',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              int dayNumber = index + 1;
              bool isToday = dayNumber == 11;
              bool hasEvents = [11, 14, 18, 22].contains(dayNumber);

              return Container(
                decoration: BoxDecoration(
                  color: isToday
                      ? const Color(0xFF1E5E2F)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isToday
                        ? const Color(0xFF1E5E2F)
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isToday
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (hasEvents) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.amber
                              : const Color(0xFF1E5E2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgressCard(int completedCount, double progressValue) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
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
              Row(
                children: [
                  Text(
                    "Today's Goal Progress ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Text("🎯", style: TextStyle(fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade100, Colors.orange.shade50],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '5 Day Streak',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$completedCount of ${_tasks.length} tasks completed',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1E5E2F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFF0284C7),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF334155),
                  height: 1.3,
                ),
                children: [
                  TextSpan(
                    text: 'AI Study Insight: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                  TextSpan(
                    text:
                        'Your peak focus time is 09:00 AM. Great job starting Biology early!',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _subjects.map((subj) {
          final isSelected = _selectedSubjectFilter == subj;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: isSelected,
              label: Text(subj),
              selected: isSelected,
              selectedColor: const Color(0xFF1E5E2F),
              backgroundColor: Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  _selectedSubjectFilter = subj;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    bool isCompleted = task['isCompleted'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFFBBF7D0)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: isCompleted,
              activeColor: const Color(0xFF1E5E2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) {
                setState(() {
                  task['isCompleted'] = val;
                });
              },
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: task['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        task['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? const Color(0xFF9CA3AF)
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // PRIORITY BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: task['priority'] == 'HIGH'
                            ? Colors.red.shade50
                            : task['priority'] == 'MED'
                            ? Colors.amber.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task['priority'],
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: task['priority'] == 'HIGH'
                              ? Colors.red.shade700
                              : task['priority'] == 'MED'
                              ? Colors.amber.shade800
                              : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task['subject'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        task['time'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Start Focus Session',
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFF1E5E2F),
              size: 30,
            ),
            onPressed: () => _showFocusTimerModal(task['title']),
          ),
          IconButton(
            tooltip: 'Delete Task',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFEF4444),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _tasks.removeWhere((t) => t['id'] == task['id']);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(Icons.timer_outlined, 'Total Focus', '4.5 hrs'),
          Container(
            height: 30,
            width: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _buildSummaryItem(
            Icons.check_circle_outline,
            'Completed',
            '${_tasks.where((t) => t['isCompleted']).length} Tasks',
          ),
          Container(
            height: 30,
            width: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _buildSummaryItem(Icons.insights, 'Efficiency', '92% 📊'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1E5E2F)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 48,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 8),
          Text(
            'No tasks found for this filter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Tap "+ Add Task" to schedule a study session.',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================

  void _showAddTaskBottomSheet() {
    final titleController = TextEditingController();
    String selectedSubj = 'Biology 101';
    String selectedType = 'Assignment 📝';

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
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '➕ Add New Task / Reminder',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),

              // TASK / PROJECT TITLE
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task or Project Title',
                  hintText: 'e.g., Submit Essay / Practice Coding',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // CATEGORY / TYPE SELECTOR (ASSIGNMENT, PROJECT, STUDY, EXAM)
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  labelText: 'Category / Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    [
                      'Assignment 📝',
                      'Project 🎨',
                      'Study Session 📖',
                      'Exam Prep 🚨',
                    ].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (val) {
                  if (val != null) selectedType = val;
                },
              ),
              const SizedBox(height: 14),

              // SUBJECT DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: selectedSubj,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Biology 101', 'Computer Prog 2', 'Phil History'].map((
                  s,
                ) {
                  return DropdownMenuItem(value: s, child: Text(s));
                }).toList(),
                onChanged: (val) {
                  if (val != null) selectedSubj = val;
                },
              ),
              const SizedBox(height: 20),

              // SAVE BUTTON
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
                    if (titleController.text.trim().isNotEmpty) {
                      // Smart priority and color based on category
                      String priority = 'MED';
                      Color taskColor = const Color(0xFF10B981);

                      if (selectedType.contains('Project') ||
                          selectedType.contains('Exam')) {
                        priority = 'HIGH';
                        taskColor = const Color(0xFFEF4444);
                      } else if (selectedType.contains('Assignment')) {
                        priority = 'MED';
                        taskColor = const Color(0xFFF59E0B);
                      }

                      String emoji = selectedType.split(' ').last;

                      setState(() {
                        _tasks.add({
                          'id': DateTime.now().millisecondsSinceEpoch
                              .toString(),
                          'title': '$emoji ${titleController.text.trim()}',
                          'subject': selectedSubj,
                          'time':
                              selectedType.contains('Assignment') ||
                                  selectedType.contains('Project')
                              ? '11:59 PM (Deadline)'
                              : '02:00 PM - 03:30 PM',
                          'isCompleted': false,
                          'priority': priority,
                          'color': taskColor,
                          'day': 11,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Task / Reminder',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetailedAnalyticsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '📊 Weekly Study Analytics',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildAnalyticsRow('Biology 101', '2.5 hrs', 0.8, Colors.green),
              _buildAnalyticsRow(
                'Computer Prog 2',
                '1.5 hrs',
                0.5,
                Colors.amber,
              ),
              _buildAnalyticsRow('Phil History', '0.5 hrs', 0.2, Colors.blue),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5E2F),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Analytics'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsRow(
    String subject,
    String time,
    double ratio,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: ratio,
            color: color,
            backgroundColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  void _showFocusTimerModal(String taskTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 360,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '⏱️ Focus Session',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                taskTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 8,
                      color: Color(0xFF1E5E2F),
                      backgroundColor: Colors.black12,
                    ),
                  ),
                  Column(
                    children: const [
                      Text(
                        '25:00',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pomodoro',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E5E2F),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Focus session started! Good luck! 🎉'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Timer'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAiAutoScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.auto_awesome, color: Color(0xFFFBBF24)),
              SizedBox(width: 8),
              Text('Smart AI Auto-Planner', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: const Text(
            'The AI analyzed your weak points in Analytics. Would you like it to automatically generate recommended tasks for this week?',
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5E2F),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '✨ AI generated 2 recommended tasks for you!',
                    ),
                  ),
                );
              },
              child: const Text('Generate Tasks'),
            ),
          ],
        );
      },
    );
  }
}
