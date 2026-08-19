import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_player_state.dart';

/// Bottom sheet to pick a sleep-timer duration.
/// FRONTEND ONLY — sets [MusicPlayerState.sleepTimerRemaining]; the
/// actual countdown/auto-pause logic should be wired up alongside
/// your real audio engine.
void showSleepTimerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SleepTimerSheet(),
  );
}

class _SleepTimerSheet extends StatelessWidget {
  const _SleepTimerSheet();

  static const _options = [5, 10, 15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    final state = MusicPlayerState.instance;

    return Container(
      decoration: const BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 16),
          const Text('Sleep Timer', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ..._options.map((mins) => ListTile(
                title: Text('$mins minutes', style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: state.sleepTimerRemaining?.inMinutes == mins ? const Icon(Icons.check, color: kRedColor) : null,
                onTap: () {
                  state.setSleepTimer(Duration(minutes: mins));
                  Navigator.of(context).pop();
                },
              )),
          if (state.sleepTimerRemaining != null)
            ListTile(
              title: const Text('Turn off', style: TextStyle(color: kRedColor, fontSize: 14)),
              onTap: () {
                state.setSleepTimer(null);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}