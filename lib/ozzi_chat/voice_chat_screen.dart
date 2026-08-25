import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

enum VoiceState { idle, listening, thinking, speaking }

/// FRONTEND ONLY — the orb animates continuously and [state] just
/// changes its color/behavior for show. Wire up real speech-to-text /
/// AI response / text-to-speech logic wherever the // TODO comments
/// are, and drive [state] from that instead of the demo auto-cycle
/// below. No manual mic button — this screen auto-listens, and you
/// should call [_setState]-style transitions from your real
/// speech-detection callbacks (e.g. "user started talking" ->
/// listening, "user stopped talking" -> thinking -> speaking).
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotateController;
  late final AnimationController _smokeController;
  VoiceState _state = VoiceState.idle;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    // TODO: replace this whole demo auto-cycle with real hooks:
    //   - speech-to-text "onSpeechStart"  -> setState(() => _state = VoiceState.listening)
    //   - speech-to-text "onSpeechEnd"    -> setState(() => _state = VoiceState.thinking)
    //   - AI response ready               -> setState(() => _state = VoiceState.speaking)
    //   - TTS playback finished           -> setState(() => _state = VoiceState.idle/listening)
    // Below just cycles automatically so the screen has no manual
    // button and always looks "alive" listening on its own.
    _startAutoCycle();
  }

  Future<void> _startAutoCycle() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      setState(() {
        switch (_state) {
          case VoiceState.idle:
          case VoiceState.listening:
            _state = VoiceState.thinking;
          case VoiceState.thinking:
            _state = VoiceState.speaking;
          case VoiceState.speaking:
            _state = VoiceState.listening;
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  String get _statusText {
    switch (_state) {
      case VoiceState.idle:
        return 'Listening...';
      case VoiceState.listening:
        return 'Listening...';
      case VoiceState.thinking:
        return 'Thinking...';
      case VoiceState.speaking:
        return 'Speaking...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhoneFrame(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 8,
                left: 20,
                child: OzziBackButton(),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOrb(),
                    const SizedBox(height: 40),
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrb() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotateController, _smokeController]),
      builder: (context, child) {
        final pulse = 0.9 + (_pulseController.value * 0.15); // breathing scale
        final glow = 0.35 + (_pulseController.value * 0.25);
        final smokeAngle = _smokeController.value * 2 * pi;
        final smokeAngle2 = (_smokeController.value * 2 * pi * -0.7) + pi / 3;

        return SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Soft outer glow — reacts to voice state.
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _orbGlowColor.withValues(alpha: glow),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),

              // Smoky drifting core — layered blurred gradients that
              // rotate at different speeds/directions to read as
              // smoke rather than a hard swirl.
              ClipOval(
                child: Transform.scale(
                  scale: pulse,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: smokeAngle,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    _orbGlowColor.withValues(alpha: 0.0),
                                    _orbGlowColor.withValues(alpha: 0.55),
                                    Colors.white.withValues(alpha: 0.35),
                                    _orbGlowColor.withValues(alpha: 0.0),
                                  ],
                                  stops: const [0.0, 0.3, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: smokeAngle2,
                            child: Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.0),
                                    const Color(0xFFB8C2FF).withValues(alpha: 0.4),
                                    Colors.white.withValues(alpha: 0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Inner radial highlight for a glossy, soft-core feel.
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.2, -0.3),
                      radius: 0.9,
                      colors: [
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color get _orbGlowColor {
    switch (_state) {
      case VoiceState.listening:
        return kRedColor;
      case VoiceState.thinking:
        return const Color(0xFFB8C2FF);
      case VoiceState.speaking:
        return const Color(0xFF6C7BFF);
      case VoiceState.idle:
        return const Color(0xFF6C7BFF);
    }
  }
}