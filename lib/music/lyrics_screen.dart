import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_player_state.dart';

/// Full-screen lyrics view, synced to playback position.
/// FRONTEND ONLY — [song.lyrics] style data would come from your
/// backend/lyrics API; pass the parsed [LyricLine] list in via [lines].
class LyricsScreen extends StatelessWidget {
  final Song song;
  final List<LyricLine> lines;

  const LyricsScreen({super.key, required this.song, this.lines = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: MusicPlayerState.instance,
            builder: (context, _) {
              final position = MusicPlayerState.instance.currentPosition;
              final activeIndex = lines.lastIndexWhere((l) => l.timestamp <= position);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        const OzziBackButton(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text(song.artistName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: lines.isEmpty
                        ? Center(child: Text('No lyrics available', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            itemCount: lines.length,
                            itemBuilder: (context, i) {
                              final isActive = i == activeIndex;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  lines[i].text,
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey.shade600,
                                    fontSize: isActive ? 20 : 17,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}