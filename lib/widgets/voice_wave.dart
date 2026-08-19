import 'dart:math';
import 'package:flutter/material.dart';

/// Generic reusable voice waveform — static (for message previews)
/// or animated (for active recording/listening states). FRONTEND ONLY.
class VoiceWave extends StatefulWidget {
  final int barCount;
  final double height;
  final Color color;
  final bool isAnimating;

  const VoiceWave({
    super.key,
    this.barCount = 18,
    this.height = 24,
    this.color = Colors.white,
    this.isAnimating = false,
  });

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _seeds;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    _seeds = List.generate(widget.barCount, (_) => rand.nextDouble());
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    if (widget.isAnimating) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant VoiceWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.barCount, (i) {
              final base = 0.3 + _seeds[i] * 0.7;
              final animated = widget.isAnimating ? base * (0.4 + _controller.value * 0.6) : base;
              return Container(
                width: 3,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                height: widget.height * animated,
                decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(2)),
              );
            }),
          );
        },
      ),
    );
  }
}