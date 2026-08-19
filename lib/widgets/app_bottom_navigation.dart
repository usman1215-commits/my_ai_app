import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// THE canonical main-tab bottom navigation for the app — 7 tabs:
/// Home, Ozzi Chat, Messages, Notes, Music, Safe Folder, Settings.
/// Used only by [MainShell] (lib/navigation/main_shell.dart).
///
/// Profile is intentionally NOT a tab here — it's reachable via
/// Settings → Profile instead (see settings_home_screen.dart).
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.auto_awesome, label: 'Ozzi'),
    (icon: Icons.chat_bubble_rounded, label: 'Messages'),
    (icon: Icons.notes_rounded, label: 'Notes'),
    (icon: Icons.music_note_rounded, label: 'Music'),
    (icon: Icons.lock_rounded, label: 'Safe'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        border: Border(top: BorderSide(color: Color(0xFF2E2E2E), width: 0.6)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final isActive = i == currentIndex;
            final item = _items[i];
            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: isActive ? kRedColor : Colors.grey.shade500, size: 21),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isActive ? kRedColor : Colors.grey.shade500,
                        fontSize: 9.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}