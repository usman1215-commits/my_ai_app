import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Liked Songs — special heart-header playlist-like screen.
/// FRONTEND ONLY — [songs] placeholder list from your backend.
class LikedSongsScreen extends StatelessWidget {
  final List<Song> songs;

  const LikedSongsScreen({super.key, this.songs = const []});

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
                child: Row(children: const [OzziBackButton()]),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Center(
                      child: Container(
                        width: 140, height: 140,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [kRedColor, Color(0xFF7B2020)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white, size: 56),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Liked Songs', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    Text('${songs.length} songs', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: songs.isEmpty ? null : () => MusicPlayerState.instance.playSong(songs.first, fromQueue: songs),
                      child: Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (songs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('Songs you like will appear here', style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
                      )
                    else
                      ...songs.asMap().entries.map((e) => SongTile(song: e.value, index: e.key, onTap: () => MusicPlayerState.instance.playSong(e.value, fromQueue: songs))),
                    const SizedBox(height: 90),
                  ],
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