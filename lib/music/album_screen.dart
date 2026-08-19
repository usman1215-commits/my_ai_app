import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Album detail — header art/title/artist/year + track list.
/// FRONTEND ONLY — [album.songs] comes from your backend.
class AlbumScreen extends StatelessWidget {
  final Album album;

  const AlbumScreen({super.key, required this.album});

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
                    Center(child: MusicArt(url: album.coverUrl, size: 180, radius: 14)),
                    const SizedBox(height: 16),
                    Text(album.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '${album.artistName}${album.releaseYear != null ? ' · ${album.releaseYear}' : ''}',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: album.songs.isEmpty ? null : () => MusicPlayerState.instance.playSong(album.songs.first, fromQueue: album.songs),
                      child: Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (album.songs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('No tracks yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
                      )
                    else
                      ...album.songs.asMap().entries.map((e) => SongTile(
                            song: e.value,
                            index: e.key,
                            showAlbumArt: false,
                            onTap: () => MusicPlayerState.instance.playSong(e.value, fromQueue: album.songs),
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