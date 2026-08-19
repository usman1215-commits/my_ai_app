import 'package:flutter/material.dart';

/// A consistent fade + subtle-slide-up transition used across the
/// whole app instead of the default platform transition, so every
/// screen push/pop feels the same regardless of module.
///
/// Usage:
///   Navigator.of(context).push(AppPageRoute(builder: (_) => const SomeScreen()));
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  AppPageRoute({required this.builder, super.settings})
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// A simple cross-fade transition — use for replacing an entire flow
/// (e.g. Splash -> Login, Login -> Home) where a slide would feel odd.
class AppFadeRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  AppFadeRoute({required this.builder, super.settings})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

/// A bottom-sheet-style modal transition — use for screens that
/// should slide up from the bottom (e.g. full-screen pickers).
class AppModalRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  AppModalRoute({required this.builder, super.settings})
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
              child: child,
            );
          },
        );
}