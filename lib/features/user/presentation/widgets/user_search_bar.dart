import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  const UserSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
    required this.textController,
    required this.focusNode,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController textController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(onPressed: onClear, icon: Icon(Icons.close)),
      ),
      onChanged: onChanged,
    );
  }
}
