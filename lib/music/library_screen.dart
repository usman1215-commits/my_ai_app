import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'playlist_screen.dart';
import 'album_screen.dart';
import 'artist_screen.dart';
import 'liked_songs_screen.dart';
import 'downloads_screen.dart';
import 'local_music_screen.dart';

/// User's Library — tabs for Playlists / Albums / Artists, plus
/// quick shortcuts to Liked Songs, Downloads, Local Music.
/// FRONTEND ONLY — all lists are placeholders from your backend.
class LibraryScreen extends StatefulWidget {
  final List<Playlist> playlists;
  final List<Album> albums;
  final List<Artist> artists;

  const LibraryScreen({super.key, this.playlists = const [], this.albums = const [], this.artists = const []});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('Your Library', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _shortcutChip('Liked Songs', Icons.favorite, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LikedSongsScreen()))),
                    const SizedBox(width: 8),
                    _shortcutChip('Downloads', Icons.download_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DownloadsScreen()))),
                    const SizedBox(width: 8),
                    _shortcutChip('Local Music', Icons.folder_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LocalMusicScreen()))),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kRedColor,
                tabs: const [Tab(text: 'Playlists'), Tab(text: 'Albums'), Tab(text: 'Artists')],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _list(widget.playlists.map((p) => _row(p.title, p.createdBy, p.coverUrl, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: p))))).toList()),
                    _list(widget.albums.map((a) => _row(a.title, a.artistName, a.coverUrl, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumScreen(album: a))))).toList()),
                    _list(widget.artists.map((a) => _row(a.name, 'Artist', a.imageUrl, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArtistScreen(artist: a))), isCircle: true)).toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shortcutChip(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: kFieldColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Column(
              children: [
                Icon(icon, color: kRedColor, size: 20),
                const SizedBox(height: 6),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String? subtitle, String? art, VoidCallback onTap, {bool isCircle = false}) {
    return ListTile(
      onTap: onTap,
      leading: MusicArt(url: art, size: 48, radius: 6, isCircle: isCircle),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)) : null,
    );
  }

  Widget _list(List<Widget> items) {
    if (items.isEmpty) {
      return Center(child: Text('Nothing here yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)));
    }
    return ListView(padding: const EdgeInsets.symmetric(horizontal: 8), children: items);
  }
}