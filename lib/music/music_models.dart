/// Shared data models for the Music module.
/// FRONTEND ONLY — every field is meant to be populated from your
/// backend/streaming API/local device storage. Nothing here is
/// hardcoded data, just the shape of the data.
library;

class Song {
  final String id;
  final String title;
  final String artistName;
  final String? albumName;
  final String? artUrl;
  final Duration duration;
  final bool isLiked;
  final bool isDownloaded;
  final bool isLocal;

  Song({
    required this.id,
    required this.title,
    required this.artistName,
    this.albumName,
    this.artUrl,
    this.duration = Duration.zero,
    this.isLiked = false,
    this.isDownloaded = false,
    this.isLocal = false,
  });
}

class Playlist {
  final String id;
  final String title;
  final String? description;
  final String? coverUrl;
  final String? createdBy;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    this.createdBy,
    this.songs = const [],
  });
}

class Album {
  final String id;
  final String title;
  final String artistName;
  final String? coverUrl;
  final int? releaseYear;
  final List<Song> songs;

  Album({
    required this.id,
    required this.title,
    required this.artistName,
    this.coverUrl,
    this.releaseYear,
    this.songs = const [],
  });
}

class Artist {
  final String id;
  final String name;
  final String? imageUrl;
  final int? monthlyListeners;
  final List<Song> topSongs;
  final List<Album> albums;

  Artist({
    required this.id,
    required this.name,
    this.imageUrl,
    this.monthlyListeners,
    this.topSongs = const [],
    this.albums = const [],
  });
}

class LyricLine {
  final Duration timestamp;
  final String text;

  LyricLine({required this.timestamp, required this.text});
}

enum SongRepeatMode { off, all, one }