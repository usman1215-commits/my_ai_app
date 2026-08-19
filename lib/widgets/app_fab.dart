
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable floating action button — circular icon-only, or
/// extended with a label. Matches the app's red accent everywhere
/// a FAB is needed (Notes, Safe Folder, etc).
class AppFab extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const AppFab({super.key, required this.icon, this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: kRedColor, borderRadius: BorderRadius.circular(26)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label!, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}