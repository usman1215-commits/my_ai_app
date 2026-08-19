
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable music card — song/album/playlist art + title +
/// subtitle. Not tied to the music module's own models, so it can be
/// reused anywhere a piece of music needs a card. FRONTEND ONLY.
class MusicCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? artUrl;
  final bool isCircle;
  final double size;
  final VoidCallback onTap;
  final Widget? trailing;

  const MusicCard({
    super.key,
    required this.title,
    this.subtitle,
    this.artUrl,
    this.isCircle = false,
    this.size = 128,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: isCircle ? BorderRadius.circular(size) : BorderRadius.circular(10),
                  child: Container(
                    width: size, height: size,
                    color: kFieldColor,
                    child: artUrl != null
                        ? Image.network(artUrl!, fit: BoxFit.cover)
                        : Icon(Icons.music_note_rounded, color: Colors.grey.shade600, size: size * 0.4),
                  ),
                ),
                if (trailing != null) Positioned(right: 6, bottom: 6, child: trailing!),
              ],
            ),
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