import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/routing/routes.dart';

class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(Routes.home)) return 0;
    if (location.startsWith(Routes.inbox)) return 1;
    if (location.startsWith(Routes.messages)) return 2;
    if (location.startsWith(Routes.profile)) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.inbox);
      case 2:
        context.go(Routes.messages);
      case 3:
        context.go(Routes.profile);
    }
  }
}
