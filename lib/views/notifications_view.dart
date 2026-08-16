import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationItem {
  String title;
  String subtitle;
  String time;
  String type;
  IconData icon;
  bool isUnread;

  _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.icon,
    this.isUnread = false,
  });
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<String> _filters = ['All', 'Reminders', 'Achievements', 'Alerts', 'System'];
  String _selectedFilter = 'All';

  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: 'New Reviewer Available',
      subtitle: 'Accounting 102 has been uploaded. Start reviewing now!',
      time: 'Just now',
      type: 'system',
      icon: Icons.upload_file_rounded,
      isUnread: true,
    ),
    _NotificationItem(
      title: 'Streak at Risk',
      subtitle: 'Complete 1 quiz today to keep your 5-day streak.',
      time: '15m ago',
      type: 'alert',
      icon: Icons.local_fire_department_rounded,
      isUnread: true,
    ),
    _NotificationItem(
      title: 'Rank Up',
      subtitle: 'You climbed to Rank 4 in CS2A-1.',
      time: '1h ago',
      type: 'achievement',
      icon: Icons.leaderboard_rounded,
      isUnread: true,
    ),
    _NotificationItem(
      title: 'Study Reminder',
      subtitle: '2 hours left before Biology Quiz session!',
      time: '3h ago',
      type: 'reminder',
      icon: Icons.timer_outlined,
      isUnread: false,
    ),
    _NotificationItem(
      title: 'Badge Unlocked!',
      subtitle: 'You unlocked "7-Day Streak" badge.',
      time: 'Yesterday',
      type: 'achievement',
      icon: Icons.military_tech_rounded,
      isUnread: false,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  List<_NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n.type == _selectedFilter.toLowerCase()).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _clearAll() {
    setState(() => _notifications.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications cleared'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  (Color, Color) _typeColors(String type) {
    switch (type) {
      case 'reminder':
        return (const Color(0xFF1E5E2F), const Color(0xFFE8F5E9));
      case 'achievement':
        return (const Color(0xFFD97706), const Color(0xFFFFF8E1));
      case 'alert':
        return (const Color(0xFFEA580C), const Color(0xFFFFF3E0));
      case 'system':
      default:
        return (const Color(0xFF0284C7), const Color(0xFFE0F2FE));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          TextButton.icon(
            onPressed: _unreadCount > 0 ? _markAllAsRead : null,
            style: TextButton.styleFrom(foregroundColor: Colors.white, disabledForegroundColor: Colors.white38),
            icon: const Icon(Icons.done_all_rounded, size: 18),
            label: const Text('Mark all as read', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
child: Center(
              heightFactor: 1,
              child: Row(
                children: [
                  for (final filter in _filters) ...[
                    _buildFilterChip(filter),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_rounded, size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No notifications yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : _filteredNotifications.isEmpty
                    ? Center(
                        child: Text(
                          'No notifications in this category',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) => _buildNotificationCard(_filteredNotifications[index]),
                      ),
          ),
          if (_notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _clearAll,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB91C1C),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    backgroundColor: const Color(0xFFFEF2F2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                  label: const Text('Clear All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;
    return ChoiceChip(
      visualDensity: VisualDensity.compact,
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF64748B))),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = label),
      selectedColor: const Color(0xFF1E5E2F),
      backgroundColor: Colors.white,
      showCheckmark: false,
      side: BorderSide(color: isSelected ? const Color(0xFF1E5E2F) : Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    final (Color iconColor, Color bgColor) = _typeColors(item.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUnread ? const Color(0xFF1E5E2F).withValues(alpha: 0.25) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(item.icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ),
                    if (item.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                ),
                const SizedBox(height: 6),
                Text(item.time, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}