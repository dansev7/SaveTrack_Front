import 'package:flutter/material.dart';
import 'package:save_track/features/profile/profile_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/transactions/transactions_screen.dart'; // 👈 Import new screen
import '../../features/goals/goals_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _navigateToTransactions() {
    setState(() => _currentIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onNavigateToTransactions: _navigateToTransactions),
      const TransactionsScreen(),
      const GoalsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF121212),
        indicatorColor: Colors.tealAccent.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.dashboard, color: Colors.tealAccent),
            label: 'Dashboard',
          ),
          // 👈 Add Middle Tab
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.receipt_long, color: Colors.tealAccent),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.track_changes, color: Colors.tealAccent),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white54),
            selectedIcon: Icon(Icons.person, color: Colors.tealAccent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}