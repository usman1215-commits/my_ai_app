import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_player_state.dart';
import 'music_widgets.dart';
import 'lyrics_screen.dart';
import 'queue_screen.dart';
import 'sleep_timer_sheet.dart';
import 'equalizer_screen.dart';

/// Full-screen Now Playing view — big art, seek bar, transport
/// controls, shuffle/repeat, and shortcuts to Lyrics & Queue.
/// FRONTEND ONLY — reads/writes [MusicPlayerState].
class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

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
              final song = state.currentSong;

              if (song == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const OzziBackButton(),
                      const SizedBox(height: 20),
                      Text('Nothing playing', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28)),
                        const Spacer(),
                        Text('PLAYING FROM', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, letterSpacing: 1)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QueueScreen())),
                          icon: const Icon(Icons.queue_music_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),

                    AspectRatio(
                      aspectRatio: 1,
                      child: Hero(
                        tag: 'music-art-${song.id}',
                        child: MusicArt(url: song.artUrl, size: 400, radius: 16),
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(song.artistName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 13.5)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: state.toggleLike,
                          icon: Icon(song.isLiked ? Icons.favorite : Icons.favorite_border, color: song.isLiked ? kRedColor : Colors.white, size: 24),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        activeTrackColor: kRedColor,
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(value: state.progress.clamp(0, 1), onChanged: state.seekTo),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(state.currentPosition), style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        Text(formatDuration(song.duration), style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: state.toggleShuffle,
                          icon: Icon(Icons.shuffle_rounded, color: state.isShuffle ? kRedColor : Colors.grey.shade400, size: 22),
                        ),
                        IconButton(onPressed: state.playPrevious, icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 34)),
                        GestureDetector(
                          onTap: state.togglePlayPause,
                          child: Container(
                            width: 62, height: 62,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow, color: kBackgroundColor, size: 34),
                          ),
                        ),
                        IconButton(onPressed: state.playNext, icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 34)),
                        IconButton(
                          onPressed: state.cycleSongRepeatMode,
                          icon: Icon(
                            state.repeatMode == SongRepeatMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                            color: state.repeatMode == SongRepeatMode.off ? Colors.grey.shade400 : kRedColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LyricsScreen(song: song))),
                          icon: const Icon(Icons.lyrics_outlined, color: Colors.grey, size: 18),
                          label: Text('Lyrics', style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                        ),
                        TextButton.icon(
                          onPressed: () => showSleepTimerSheet(context),
                          icon: Icon(Icons.bedtime_outlined, color: state.sleepTimerRemaining != null ? kRedColor : Colors.grey, size: 18),
                          label: Text(
                            state.sleepTimerRemaining != null ? formatDuration(state.sleepTimerRemaining!) : 'Sleep Timer',
                            style: TextStyle(color: state.sleepTimerRemaining != null ? kRedColor : Colors.grey.shade400, fontSize: 12.5),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EqualizerScreen())),
                          icon: const Icon(Icons.equalizer_rounded, color: Colors.grey, size: 18),
                          label: Text('Equalizer', style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}