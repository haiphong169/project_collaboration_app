import 'package:flutter/material.dart';
import 'package:project_collaboration_app/ui/auth/logout/view_models/logout_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.viewModel});

  final LogoutViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: viewModel.logout, child: Text("Logout")),
    );
  }
}
