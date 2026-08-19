import 'dart:math';
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

enum VoiceState { idle, listening, thinking, speaking }

/// FRONTEND ONLY — the orb animates continuously and [state] just
/// changes its color/behavior for show. Wire up real speech-to-text /
/// AI response / text-to-speech logic wherever the // TODO comments
/// are, and drive [state] from that instead of the demo cycling below.
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotateController;
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
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    // TODO: replace with real mic / speech-to-text trigger.
    setState(() {
      _state = _state == VoiceState.listening ? VoiceState.idle : VoiceState.listening;
    });
  }

  String get _statusText {
    switch (_state) {
      case VoiceState.idle:
        return 'Tap to speak';
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
              Positioned(
                top: 8,
                left: 20,
                child: const OzziBackButton(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
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
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: GestureDetector(
                      onTap: _toggleListening,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _state == VoiceState.listening ? kRedColor : kFieldColor,
                        ),
                        child: Icon(
                          _state == VoiceState.listening ? Icons.stop_rounded : Icons.mic_none_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrb() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotateController]),
      builder: (context, child) {
        final pulse = 0.9 + (_pulseController.value * 0.15); // breathing scale
        final glow = 0.35 + (_pulseController.value * 0.25);

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

              // Rotating swirl gradient sphere (matches the reference orb).
              Transform.scale(
                scale: pulse,
                child: Transform.rotate(
                  angle: _rotateController.value * 2 * pi,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Color(0xFF6C7BFF),
                          Color(0xFFFFFFFF),
                          Color(0xFFB8C2FF),
                          Color(0xFF6C7BFF),
                        ],
                        stops: [0.0, 0.35, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Inner radial highlight for a glossy, 3D sphere feel.
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      radius: 0.9,
                      colors: [
                        Color(0xCCFFFFFF),
                        Color(0x00FFFFFF),
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