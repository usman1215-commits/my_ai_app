import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// THE canonical main-tab bottom navigation for the app — 8 tabs:
/// Home, Ozzi Chat, Messages, Notes, Music, Safe Folder, Profile, Settings.
/// Used only by [MainShell] (lib/navigation/main_shell.dart), rendered
/// INSIDE [PhoneFrame] so it always stays phone-width.
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
    (icon: Icons.chat_bubble_rounded, label: 'Chats'),
    (icon: Icons.notes_rounded, label: 'Notes'),
    (icon: Icons.music_note_rounded, label: 'Music'),
    (icon: Icons.lock_rounded, label: 'Safe'),
    (icon: Icons.person_rounded, label: 'Profile'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 6,
        right: 6,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: SizedBox(
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final isActive = i == currentIndex;
            final item = _items[i];
            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(14),
                  splashColor: kRedColor.withValues(alpha: 0.15),
                  highlightColor: kRedColor.withValues(alpha: 0.08),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isActive ? kRedColor.withValues(alpha: 0.14) : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isActive ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            item.icon,
                            color: isActive ? kRedColor : Colors.grey.shade500,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: TextStyle(
                            color: isActive ? kRedColor : Colors.grey.shade500,
                            fontSize: 9,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}