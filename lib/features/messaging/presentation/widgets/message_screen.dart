import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 48),
            MessageSearchBar(
              onTap: () {
                context.push(Routes.userSearch);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSearchBar extends StatelessWidget {
  const MessageSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true, // key
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "Search users...",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
