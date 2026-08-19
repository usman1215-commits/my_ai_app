import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Downloads — offline-saved songs + storage usage indicator.
/// FRONTEND ONLY — [songs] and [usedStorageBytes]/[totalStorageBytes]
/// come from your backend/device storage APIs.
class DownloadsScreen extends StatelessWidget {
  final List<Song> songs;
  final int? usedStorageBytes;
  final int? totalStorageBytes;

  const DownloadsScreen({super.key, this.songs = const [], this.usedStorageBytes, this.totalStorageBytes});

  String _formatBytes(int? bytes) {
    if (bytes == null) return '--';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (usedStorageBytes != null && totalStorageBytes != null && totalStorageBytes! > 0)
        ? (usedStorageBytes! / totalStorageBytes!).clamp(0.0, 1.0)
        : 0.0;

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
                    Text('Downloads', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: ratio, minHeight: 6, backgroundColor: kFieldColor, valueColor: const AlwaysStoppedAnimation(kRedColor)),
                    ),
                    const SizedBox(height: 6),
                    Text('${_formatBytes(usedStorageBytes)} of ${_formatBytes(totalStorageBytes)} used', style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
                  ],
                ),
              ),
              Expanded(
                child: songs.isEmpty
                    ? Center(child: Text('No downloaded songs', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
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