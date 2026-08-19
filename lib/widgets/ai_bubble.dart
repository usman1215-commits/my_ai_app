
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Chat bubble styled specifically for AI (Ozzi) responses — small
/// AI avatar/icon beside a left-aligned bubble. Distinct from a
/// generic user MessageBubble so AI replies are visually recognizable.
/// FRONTEND ONLY.
class AiBubble extends StatelessWidget {
  final String text;
  final bool isTyping;

  const AiBubble({super.key, required this.text, this.isTyping = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26, height: 26,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 13),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kFieldColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: isTyping ? const _TypingDots() : Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
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
                child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              );
            }),
          );
        },
      ),
    );
  }
}