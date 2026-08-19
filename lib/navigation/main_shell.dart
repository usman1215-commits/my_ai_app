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

/// The app's real main-tab shell — hosts the 7 top-level sections
/// behind a single persistent [BottomNavigation] bar:
/// Home, Ozzi Chat, Messages, Notes, Music, Safe Folder, Settings.
///
/// IMPORTANT: tabs are built LAZILY — a tab's screen is only
/// constructed the first time you actually visit it (not all 7 at
/// once when the shell first loads). This keeps first-load fast and
/// means an issue in one tab can't affect the others / block the
/// whole shell from rendering. Once visited, a tab's state is kept
/// alive via IndexedStack (switching away and back preserves it).
///
/// Wrapped in [PhoneFrame] like every other screen in the app, so it
/// stays phone-width on wide/desktop browser previews instead of
/// stretching edge-to-edge.
///
/// Profile is intentionally NOT one of these tabs — it's reached via
/// Settings → Profile instead.
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  late final List<bool> _visited;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _visited = List.filled(8, false);
    _visited[_currentIndex] = true;
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      _visited[index] = true;
    });
  }

  Widget _buildTab(int index) {
    if (!_visited[index]) return const SizedBox.shrink();
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const OzziScreen();
      case 2:
        return const MessagesHomeScreen();
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
        child: IndexedStack(
          index: _currentIndex,
          children: List.generate(8, _buildTab),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

/// Wraps Safe Folder's PIN-lock flow so it works correctly as a tab.
///
/// [SafeFolderLockScreen] normally does a `pushReplacement` to
/// [SafeFolderHomeScreen] on unlock (fine when opened as its own
/// pushed screen, e.g. from Settings). But inside a tab, replacing
/// the route would blow away the whole [MainShell] — so here we
/// instead swap local widget state between the lock screen and the
/// unlocked home screen, keeping the shell (and other tabs) intact.
/// Switching tabs away and back re-locks it, which is the expected/
/// safe behavior for a security folder.
class _SafeFolderTab extends StatefulWidget {
  const _SafeFolderTab();

  @override
  State<_SafeFolderTab> createState() => _SafeFolderTabState();
}

class _SafeFolderTabState extends State<_SafeFolderTab> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return SafeFolderLockScreen(
        onUnlocked: () => setState(() => _unlocked = true),
      );
    }
    return const SafeFolderHomeScreen();
  }
}