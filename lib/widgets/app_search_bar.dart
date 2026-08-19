
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable rounded search bar. Used across every module's
/// search screen (Messages, Music, Notes, etc). FRONTEND ONLY —
/// [onChanged] fires as the user types; wire up your real
/// search/filter logic in the caller.
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final VoidCallback? onFilterTap;

  const AppSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade500)),
            ),
          ),
          if (onFilterTap != null)
            GestureDetector(
              onTap: onFilterTap,
              child: Icon(Icons.tune, color: Colors.grey.shade500, size: 20),
            ),
        ],
      ),
    );
  }
}