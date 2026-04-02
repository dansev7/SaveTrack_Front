import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/goals/goals_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const GoalsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF121212),
        indicatorColor: Colors.tealAccent.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.dashboard, color: Colors.tealAccent),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.track_changes, color: Colors.tealAccent),
            label: 'Goals',
          ),
        ],
      ),
    );
  }
}