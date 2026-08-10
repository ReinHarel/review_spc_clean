import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E5E2F),
        elevation: 0,
        title: const Text('Notifications 🔔', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.timer_outlined, color: Color(0xFF1E5E2F)),
              ),
              title: Text('Study Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('2 hours left before Biology Quiz session!'),
              trailing: Text('10m ago', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFFFF8E1),
                child: Icon(Icons.emoji_events_outlined, color: Colors.orange),
              ),
              title: Text('Badge Unlocked!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('You unlocked "7-Day Streak" badge.'),
              trailing: Text('1h ago', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}