import 'package:flutter/material.dart';

import '../screens/ozzi_widgets.dart';
import '../home_screen/home_screen.dart';
import '../ozzi_chat/ozzi_screen.dart';
import '../messages/messages_home_screen.dart';
import '../notes/notes_home_screen.dart';
import '../music/music_home_screen.dart';
import '../safe_folder/safe_folder_lock_screen.dart';
import '../safe_folder/safe_folder_home_screen.dart';
import '../settings/settings_home_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/profile_models.dart';
import '../widgets/bottom_navigation.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  late final List<bool> _visited;

  static const int _tabCount = 8;

  @override
  void initState() {
    super.initState();

    _currentIndex =
        widget.initialIndex.clamp(0, _tabCount - 1);

    _visited = List<bool>.filled(_tabCount, false);
    _visited[_currentIndex] = true;
  }

  void _onTap(int index) {
    if (index < 0 || index >= _tabCount) return;
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
      _visited[index] = true;
    });
  }

  Widget _buildTab(int index) {
    if (!_visited[index]) {
      return const SizedBox.shrink();
    }

    switch (index) {
      case 0:
        return const HomeScreen();

      case 1:
        return const OzziScreen();

      case 2:
        return MessagesHomeScreen();

      case 3:
        return const NotesHomeScreen();

      case 4:
        return const MusicHomeScreen();

      case 5:
        return const _SafeFolderTab();

      case 6:
        return ProfileScreen(
          profile: UserProfile(
            id: 'demo-user',
            name: 'Your Name',
            username: 'yourname',
            bio: 'Your personal profile',
            followersCount: 128,
            followingCount: 95,
            postsCount: 32,
          ),
        );

      case 7:
        return const SettingsHomeScreen();

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,

      body: PhoneFrame(
        child: Column(
          children: [
            Expanded(
              child: ClipRect(
                child: IndexedStack(
                  index: _currentIndex,
                  children: List<Widget>.generate(
                    _tabCount,
                    _buildTab,
                  ),
                ),
              ),
            ),
            BottomNavigation(
              currentIndex: _currentIndex,
              onTap: _onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _SafeFolderTab extends StatefulWidget {
  const _SafeFolderTab();

  @override
  State<_SafeFolderTab> createState() => _SafeFolderTabState();
}

class _SafeFolderTabState extends State<_SafeFolderTab> {
  bool _unlocked = false;

  void _handleUnlocked() {
    if (!mounted) return;

    setState(() {
      _unlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) {
      return const SafeFolderHomeScreen();
    }

    return SafeFolderLockScreen(
      onUnlocked: _handleUnlocked,
    );
  }
}