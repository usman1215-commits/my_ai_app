import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_player_state.dart';

/// Equalizer — vertical band sliders + presets.
/// FRONTEND ONLY — updates [MusicPlayerState.eqBands]; wire up a
/// real audio-engine EQ (e.g. just_audio's AndroidEqualizer) later.
class EqualizerScreen extends StatelessWidget {
  const EqualizerScreen({super.key});

  static const _bandLabels = ['60Hz', '230Hz', '910Hz', '3kHz', '14kHz'];
  static const _presets = {
    'Flat': [0.0, 0.0, 0.0, 0.0, 0.0],
    'Bass Boost': [6.0, 4.0, 0.0, 0.0, 0.0],
    'Treble Boost': [0.0, 0.0, 0.0, 4.0, 6.0],
    'Vocal': [0.0, 2.0, 4.0, 2.0, 0.0],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: MusicPlayerState.instance,
            builder: (context, _) {
              final state = MusicPlayerState.instance;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: const [
                        OzziBackButton(),
                        SizedBox(width: 12),
                        Text('Equalizer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presets.entries.map((entry) {
                        final isActive = state.eqPreset == entry.key;
                        return GestureDetector(
                          onTap: () => state.applyEqPreset(entry.key, List.of(entry.value)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive ? kRedColor : kFieldColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(entry.key, style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_bandLabels.length, (i) {
                        return Column(
                          children: [
                            Text('${state.eqBands[i].toStringAsFixed(0)}dB', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kRedColor,
                                    inactiveTrackColor: Colors.grey.shade800,
                                    thumbColor: Colors.white,
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: state.eqBands[i],
                                    min: -12,
                                    max: 12,
                                    onChanged: (v) => state.setEqBand(i, v),
                                  ),
                                ),
                              ),
                            ),
                            Text(_bandLabels[i], style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5)),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}