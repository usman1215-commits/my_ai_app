import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ozzi_widgets.dart';

/// A ChatGPT-style splash screen:
/// - Logo fades + scales in with a soft ease
/// - Holds briefly
/// - Cross-fades into the next screen
class SplashScreen extends StatefulWidget {
  /// The screen to navigate to once the splash animation finishes.
  /// Optional — if you don't pass one, it defaults to a placeholder
  /// HomeScreen defined at the bottom of this file. Swap that out
  /// for your real home/chat screen once you have it.
  final Widget? nextScreen;

  /// Background color of the splash. Defaults to the same dark
  /// background used across Login/Register/Forgot Password so the
  /// splash blends straight into the rest of the app.
  final Color backgroundColor;

  const SplashScreen({
    super.key,
    this.nextScreen,
    this.backgroundColor = kBackgroundColor,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Logo scales from 0.85 -> 1.0 while fading in (0% - 45% of timeline)
    _scaleIn = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Whole splash fades out (75% - 100% of timeline) to reveal next screen
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, _) => FadeTransition(
          opacity: animation,
          child: widget.nextScreen ?? const _PlaceholderHome(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: PhoneFrame(
        backgroundColor: widget.backgroundColor,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeOut.value,
              child: Center(
                child: Opacity(
                  opacity: _fadeIn.value,
                  child: Transform.scale(
                    scale: _scaleIn.value,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: SvgPicture.asset(
            'assets/logo.svg',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}

/// Placeholder shown only if you call SplashScreen() without a nextScreen.
/// Replace this whole class (or just pass your real screen in) once you
/// have an actual home/chat screen ready.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
      ),
      body: PhoneFrame(
        child: const Center(
          child: Text(
            'Replace this with your real home screen',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}