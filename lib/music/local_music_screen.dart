import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Local Music — songs found on-device storage (not streamed).
/// FRONTEND ONLY — [songs] should come from a real device file-scan
/// (e.g. on_audio_query package) wired up later.
class LocalMusicScreen extends StatelessWidget {
  final List<Song> songs;

  const LocalMusicScreen({super.key, this.songs = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    const Text('Local Music', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // TODO: trigger a fresh device storage scan.
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: songs.isEmpty
                    ? Center(child: Text('No local music found on this device', style: TextStyle(color: Colors.grey.shade600, fontSize: 13), textAlign: TextAlign.center))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: songs.length,
                        itemBuilder: (context, i) => SongTile(song: songs[i], onTap: () => MusicPlayerState.instance.playSong(songs[i], fromQueue: songs)),
                      ),
              ),
              const MiniPlayerBar(),
            ],
          ),
        ),
      ),
    );
  }
}