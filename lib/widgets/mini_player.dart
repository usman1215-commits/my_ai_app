
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable mini player bar — art, title, subtitle, progress,
/// play/pause. Parameterized (not tied to any specific player state
/// singleton) so it can be reused for music, voice notes, or any
/// other playable content. FRONTEND ONLY.
class MiniPlayer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? artUrl;
  final bool isPlaying;
  final double progress; // 0.0 - 1.0
  final VoidCallback onPlayPause;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final bool isLiked;

  const MiniPlayer({
    super.key,
    required this.title,
    required this.subtitle,
    this.artUrl,
    required this.isPlaying,
    required this.progress,
    required this.onPlayPause,
    this.onTap,
    this.onLike,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 40, height: 40,
                    color: kBackgroundColor,
                    child: artUrl != null ? Image.network(artUrl!, fit: BoxFit.cover) : Icon(Icons.music_note_rounded, color: Colors.grey.shade600, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                ),
                if (onLike != null)
                  IconButton(
                    onPressed: onLike,
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? kRedColor : Colors.white70, size: 20),
                  ),
                IconButton(
                  onPressed: onPlayPause,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0), minHeight: 2, backgroundColor: Colors.grey.shade800, valueColor: const AlwaysStoppedAnimation(kRedColor)),
            ),
          ],
        ),
      ),
    );
  }
}