import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_player_state.dart';
import 'music_widgets.dart';

/// "Now Playing" queue — current song + up-next list, reorderable.
/// FRONTEND ONLY — reads/writes [MusicPlayerState.queue].
class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: MusicPlayerState.instance,
            builder: (context, _) {
              final state = MusicPlayerState.instance;
              final upNext = state.queue.length > state.queueIndex + 1
                  ? state.queue.sublist(state.queueIndex + 1)
                  : <dynamic>[];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: const [
                        OzziBackButton(),
                        SizedBox(width: 12),
                        Text('Queue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  if (state.currentSong != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Now Playing', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SongTile(song: state.currentSong!, onTap: () {}, isPlaying: true),
                    ),
                    const Divider(color: Color(0xFF2E2E2E), height: 24),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Next Up', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Expanded(
                    child: upNext.isEmpty
                        ? Center(child: Text('Queue is empty', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                        : ReorderableListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: upNext.length,
                            // ignore: deprecated_member_use
                            onReorder: (oldIndex, newIndex) {
                              // TODO: persist new queue order to your backend if needed.
                              if (newIndex > oldIndex) newIndex--;
                              final item = state.queue.removeAt(state.queueIndex + 1 + oldIndex);
                              state.queue.insert(state.queueIndex + 1 + newIndex, item);
                            },
                            itemBuilder: (context, i) => Padding(
                              key: ValueKey(upNext[i].id),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: SongTile(song: upNext[i], onTap: () => state.playSong(upNext[i], fromQueue: state.queue)),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}