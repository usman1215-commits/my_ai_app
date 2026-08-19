import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'playlist_screen.dart';
import 'album_screen.dart';
import 'music_search_screen.dart';
import 'library_screen.dart';

/// Music Home — Spotify-style layout: greeting, recently played grid,
/// then horizontal sections for playlists/albums.
/// FRONTEND ONLY — [recentlyPlayed], [madeForYou], [newReleases] are
/// placeholder lists from your backend/streaming API.
class MusicHomeScreen extends StatelessWidget {
  final List<Playlist> recentlyPlayed;
  final List<Playlist> madeForYou;
  final List<Album> newReleases;

  const MusicHomeScreen({
    super.key,
    this.recentlyPlayed = const [],
    this.madeForYou = const [],
    this.newReleases = const [],
  });

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(_greeting, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MusicSearchScreen())),
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LibraryScreen())),
                      icon: const Icon(Icons.library_music_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MusicSection(
                        title: 'Recently Played',
                        children: recentlyPlayed
                            .map((p) => MusicGridCard(
                                  title: p.title,
                                  subtitle: p.createdBy,
                                  artUrl: p.coverUrl,
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: p))),
                                ))
                            .toList(),
                      ),
                      MusicSection(
                        title: 'Made For You',
                        children: madeForYou
                            .map((p) => MusicGridCard(
                                  title: p.title,
                                  subtitle: p.description,
                                  artUrl: p.coverUrl,
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: p))),
                                ))
                            .toList(),
                      ),
                      MusicSection(
                        title: 'New Releases',
                        children: newReleases
                            .map((a) => MusicGridCard(
                                  title: a.title,
                                  subtitle: a.artistName,
                                  artUrl: a.coverUrl,
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumScreen(album: a))),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
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