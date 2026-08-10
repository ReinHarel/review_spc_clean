import 'package:flutter/material.dart';
import 'dashboard_view.dart';

// Placeholder views muna para sa ibang tabs kung wala pa silang mga hiwalay na file.
// Pwede mong palitan 'to sa mga tunay na files later on!
class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics'), backgroundColor: const Color(0xFF1E5E2F)),
      body: const Center(child: Text('Analytics Page Coming Soon')),
    );
  }
}

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badges & Achievements'), backgroundColor: const Color(0xFF1E5E2F)),
      body: const Center(child: Text('Badges Page Coming Soon')),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), backgroundColor: const Color(0xFF1E5E2F)),
      body: const Center(child: Text('Notifications Page Coming Soon')),
    );
  }
}

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardView(),
    AnalyticsView(),
    BadgesView(),
    NotificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E5E2F),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}