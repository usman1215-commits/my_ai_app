import 'package:flutter/material.dart';
import 'app_page_route.dart';
import 'main_shell.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';

import '../profile/profile_screen.dart';
import '../profile/profile_models.dart';

/// Central named-route table.
///
/// `home`, `ozziChat`, `messages`, `notes`, `music`, `safeFolder`,
/// `settingsHome` all resolve to [MainShell] (the real 7-tab
/// bottom-nav shell) opened at the matching tab index — so there is
/// exactly ONE instance of the main shell alive at a time, never
/// duplicate top-level screens pushed on top of each other.
///
/// `profile` is NOT a shell tab — it pushes [ProfileScreen] directly
/// as its own screen (Profile is reached via Settings → Profile).
///
/// Sub-screens *inside* a module (e.g. a specific chat, a song's
/// Full Player, a note's editor) still use direct
/// `Navigator.push(AppPageRoute(builder: (_) => SomeScreen(arg: x)))`
/// calls from within that module, since they need real data passed
/// in — named routes here are only for entry points reachable with
/// no required arguments.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const ozziChat = '/ozzi-chat';
  static const messages = '/messages';
  static const notes = '/notes';
  static const music = '/music';
  static const safeFolder = '/safe-folder';
  static const settingsHome = '/settings';

  static const profile = '/profile';

  static const _tabIndex = {
    home: 0,
    ozziChat: 1,
    messages: 2,
    notes: 3,
    music: 4,
    safeFolder: 5,
    profile: 6,
    settingsHome: 7,
  };

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return AppFadeRoute(builder: (_) => const SplashScreen(nextScreen: LoginScreen()), settings: routeSettings);

      case login:
        return AppFadeRoute(builder: (_) => const LoginScreen(), settings: routeSettings);

      case register:
        return AppPageRoute(builder: (_) => const RegisterScreen(), settings: routeSettings);

      case forgotPassword:
        return AppPageRoute(builder: (_) => const ForgotPasswordScreen(), settings: routeSettings);

      case home:
      case ozziChat:
      case messages:
      case notes:
      case music:
      case safeFolder:
      case settingsHome:
        return AppFadeRoute(
          builder: (_) => MainShell(initialIndex: _tabIndex[routeSettings.name] ?? 0),
          settings: routeSettings,
        );

      case profile:
        return AppPageRoute(
          builder: (_) => ProfileScreen(
            // TODO: replace with the real logged-in user's profile.
            profile: UserProfile(id: '', name: 'Your Name', username: 'username'),
          ),
          settings: routeSettings,
        );

      default:
        return AppPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for "${routeSettings.name}"')),
          ),
          settings: routeSettings,
        );
    }
  }
}