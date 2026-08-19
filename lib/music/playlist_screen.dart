import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Playlist detail — header art/title + song list.
/// FRONTEND ONLY — [playlist.songs] comes from your backend.
class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistScreen({super.key, required this.playlist});

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
                    Center(child: MusicArt(url: playlist.coverUrl, size: 180, radius: 14)),
                    const SizedBox(height: 16),
                    Text(playlist.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    if (playlist.description != null) ...[
                      const SizedBox(height: 4),
                      Text(playlist.description!, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ],
                    if (playlist.createdBy != null) ...[
                      const SizedBox(height: 4),
                      Text('By ${playlist.createdBy}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: playlist.songs.isEmpty ? null : () => MusicPlayerState.instance.playSong(playlist.songs.first, fromQueue: playlist.songs),
                          child: Container(
                            width: 54, height: 54,
                            decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.shuffle_rounded, color: Colors.grey.shade400, size: 22),
                        const SizedBox(width: 16),
                        Icon(Icons.download_outlined, color: Colors.grey.shade400, size: 22),
                        const Spacer(),
                        Icon(Icons.more_horiz, color: Colors.grey.shade400, size: 22),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (playlist.songs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('No songs in this playlist yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
                      )
                    else
                      ...playlist.songs.asMap().entries.map((e) => SongTile(
                            song: e.value,
                            index: e.key,
                            onTap: () => MusicPlayerState.instance.playSong(e.value, fromQueue: playlist.songs),
                          )),
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