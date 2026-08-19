import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';
import 'album_screen.dart';

/// Artist detail — header image/name/monthly listeners, popular
/// songs, and albums row. FRONTEND ONLY.
class ArtistScreen extends StatelessWidget {
  final Artist artist;

  const ArtistScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.4,
                        child: artist.imageUrl != null
                            ? Image.network(artist.imageUrl!, fit: BoxFit.cover)
                            : Container(color: kFieldColor, child: const Icon(Icons.person, color: Colors.white24, size: 60)),
                      ),
                      Positioned(
                        left: 20, bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(artist.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                            if (artist.monthlyListeners != null)
                              Text('${artist.monthlyListeners} monthly listeners', style: TextStyle(color: Colors.grey.shade300, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: artist.topSongs.isEmpty ? null : () => MusicPlayerState.instance.playSong(artist.topSongs.first, fromQueue: artist.topSongs),
                      child: Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Popular', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  if (artist.topSongs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text('No songs yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: artist.topSongs.take(5).map((s) => SongTile(song: s, onTap: () => MusicPlayerState.instance.playSong(s, fromQueue: artist.topSongs))).toList(),
                      ),
                    ),
                  MusicSection(
                    title: 'Albums',
                    children: artist.albums
                        .map((a) => MusicGridCard(
                              title: a.title,
                              subtitle: a.releaseYear?.toString(),
                              artUrl: a.coverUrl,
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumScreen(album: a))),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
              Positioned(top: 8, left: 12, child: const OzziBackButton()),
              const Positioned(bottom: 0, left: 0, right: 0, child: MiniPlayerBar()),
            ],
          ),
        ),
      ),
    );
  }
}