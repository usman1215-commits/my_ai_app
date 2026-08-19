
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Small red spinner matching the app's accent color.
/// Use for inline/button loading states.
class AppLoadingSpinner extends StatelessWidget {
  final double size;

  const AppLoadingSpinner({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation(kRedColor)),
    );
  }
}

/// Full-screen loading state — spinner + optional message. Use for
/// whole-page loading (e.g. while fetching initial data from backend).
class AppLoadingScreen extends StatelessWidget {
  final String? message;

  const AppLoadingScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoadingSpinner(size: 32),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(message!, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

/// Three bouncing dots — use for "typing"/"thinking" style indicators
/// outside of a chat bubble (e.g. inline in a list).
class AppLoadingDots extends StatefulWidget {
  final Color color;

  const AppLoadingDots({super.key, this.color = Colors.white});

  @override
  State<AppLoadingDots> createState() => _AppLoadingDotsState();
}

class _AppLoadingDotsState extends State<AppLoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 14,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              final t = (_controller.value - i * 0.2) % 1.0;
              final scale = 0.5 + (t < 0.5 ? t : 1 - t);
              return Opacity(
                opacity: 0.4 + scale * 0.6,
                child: Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Shimmering placeholder block — use while content (cards, list
/// rows, images) is loading in, instead of a blank gap.
class AppShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmerBox({super.key, this.width = double.infinity, this.height = 16, this.borderRadius = 8});

  @override
  State<AppShimmerBox> createState() => _AppShimmerBoxState();
}

class _AppShimmerBoxState extends State<AppShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2, 0),
              end: Alignment(1 + t * 2, 0),
              colors: [kFieldColor, Colors.grey.shade700, kFieldColor],
              stops: const [0.3, 0.5, 0.7],
            ),
          ),
        );
      },
    );
  }
}