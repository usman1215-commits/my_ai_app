
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import '../navigation/app_page_route.dart';
import 'music_models.dart';
import 'music_player_state.dart';
import 'full_player_screen.dart';

String formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// Square album/playlist art with rounded corners and a placeholder
/// fallback when no URL is available yet.
class MusicArt extends StatelessWidget {
  final String? url;
  final double size;
  final double radius;
  final bool isCircle;

  const MusicArt({super.key, this.url, this.size = 56, this.radius = 8, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isCircle ? BorderRadius.circular(size) : BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        color: kFieldColor,
        child: url != null
            ? Image.network(url!, fit: BoxFit.cover)
            : Icon(Icons.music_note_rounded, color: Colors.grey.shade600, size: size * 0.4),
      ),
    );
  }
}

/// A single song row used in playlists, albums, search results, queue, etc.
class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;
  final bool showAlbumArt;
  final int? index;
  final bool isPlaying;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.onMoreTap,
    this.showAlbumArt = true,
    this.index,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              if (index != null) ...[
                SizedBox(
                  width: 22,
                  child: Text('${index! + 1}', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ),
                const SizedBox(width: 6),
              ],
              if (showAlbumArt) ...[
                MusicArt(url: song.artUrl, size: 46, radius: 6),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPlaying ? kRedColor : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              if (song.isDownloaded)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.download_done_rounded, color: kRedColor, size: 16),
                ),
              if (song.isLiked)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.favorite, color: kRedColor, size: 15),
                ),
              GestureDetector(
                onTap: onMoreTap,
                child: Icon(Icons.more_vert, color: Colors.grey.shade500, size: 19),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical card used for playlist/album grids on Home & Search.
class MusicGridCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? artUrl;
  final bool isCircle;
  final VoidCallback onTap;

  const MusicGridCard({
    super.key,
    required this.title,
    this.subtitle,
    this.artUrl,
    this.isCircle = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 128,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MusicArt(url: artUrl, size: 128, radius: 10, isCircle: isCircle),
            const SizedBox(height: 8),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scroll row with a header title — used across Home/Library.
class MusicSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onSeeAll;

  const MusicSection({super.key, required this.title, required this.children, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Row(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text('See all', style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                ),
            ],
          ),
        ),
        if (children.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Nothing here yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5)),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: children.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) => children[i],
            ),
          ),
      ],
    );
  }
}

/// Persistent mini player bar — sits above the bottom nav / at the
/// bottom of music screens. Tapping it opens the Full Player.
/// FRONTEND ONLY — reads current state from [MusicPlayerState].
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MusicPlayerState.instance,
      builder: (context, _) {
        final state = MusicPlayerState.instance;
        final song = state.currentSong;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.of(context).push(AppPageRoute(builder: (_) => const FullPlayerScreen())),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-art-${song.id}',
                      child: MusicArt(url: song.artUrl, size: 40, radius: 6),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(song.artistName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: state.toggleLike,
                      icon: Icon(song.isLiked ? Icons.favorite : Icons.favorite_border, color: song.isLiked ? kRedColor : Colors.white70, size: 20),
                    ),
                    IconButton(
                      onPressed: state.togglePlayPause,
                      icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: state.progress,
                    minHeight: 2,
                    backgroundColor: Colors.grey.shade800,
                    valueColor: const AlwaysStoppedAnimation(kRedColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}