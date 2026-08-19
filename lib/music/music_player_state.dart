import 'package:flutter/foundation.dart';
import 'music_models.dart';

/// Simple in-memory "now playing" state shared across all music
/// screens (mini player, full player, queue, lyrics, etc).
///
/// FRONTEND ONLY — this does NOT play real audio. It just tracks UI
/// state (current song, play/pause, progress, queue, repeat/shuffle,
/// EQ, sleep timer) so the screens can react to it. Wire up a real
/// audio engine (e.g. just_audio) behind these same methods later.
class MusicPlayerState extends ChangeNotifier {
  MusicPlayerState._();
  static final MusicPlayerState instance = MusicPlayerState._();

  Song? currentSong;
  bool isPlaying = false;
  double progress = 0; // 0.0 - 1.0
  Duration currentPosition = Duration.zero;

  List<Song> queue = [];
  int queueIndex = 0;

  bool isShuffle = false;
  SongRepeatMode repeatMode = SongRepeatMode.off;

  // Equalizer — band gains from -12dB to +12dB, UI-only for now.
  List<double> eqBands = List.filled(5, 0.0);
  String eqPreset = 'Custom';

  Duration? sleepTimerRemaining;

  void playSong(Song song, {List<Song>? fromQueue}) {
    currentSong = song;
    isPlaying = true;
    progress = 0;
    currentPosition = Duration.zero;
    if (fromQueue != null) {
      queue = fromQueue;
      queueIndex = fromQueue.indexWhere((s) => s.id == song.id).clamp(0, fromQueue.length - 1);
    }
    // TODO: call your real audio engine's play(song) here.
    notifyListeners();
  }

  void togglePlayPause() {
    if (currentSong == null) return;
    isPlaying = !isPlaying;
    // TODO: call your real audio engine's play/pause here.
    notifyListeners();
  }

  void seekTo(double value) {
    progress = value;
    // TODO: call your real audio engine's seek() here.
    notifyListeners();
  }

  void playNext() {
    if (queue.isEmpty) return;
    if (queueIndex < queue.length - 1) {
      queueIndex++;
      playSong(queue[queueIndex], fromQueue: queue);
    }
  }

  void playPrevious() {
    if (queue.isEmpty) return;
    if (queueIndex > 0) {
      queueIndex--;
      playSong(queue[queueIndex], fromQueue: queue);
    }
  }

  void toggleLike() {
    // TODO: call your real "like song" backend API here.
    notifyListeners();
  }

  void toggleShuffle() {
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void cycleSongRepeatMode() {
    repeatMode = SongRepeatMode.values[(repeatMode.index + 1) % SongRepeatMode.values.length];
    notifyListeners();
  }

  void setEqBand(int index, double value) {
    eqBands[index] = value;
    eqPreset = 'Custom';
    notifyListeners();
  }

  void applyEqPreset(String preset, List<double> bands) {
    eqPreset = preset;
    eqBands = bands;
    notifyListeners();
  }

  void setSleepTimer(Duration? duration) {
    sleepTimerRemaining = duration;
    // TODO: start a real countdown that pauses playback when it hits zero.
    notifyListeners();
  }
}