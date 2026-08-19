/// Shared data models for the Profile module.
/// FRONTEND ONLY — every field is meant to be populated from your
/// backend/API. Nothing here is hardcoded data, just the shape.
library;

class UserProfile {
  final String id;
  final String name;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final int? followersCount;
  final int? followingCount;
  final int? postsCount;
  final DateTime? joinedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.joinedAt,
  });
}

class StoryArchiveItem {
  final String id;
  final String imageUrl;
  final DateTime postedAt;
  final int? viewCount;

  StoryArchiveItem({required this.id, required this.imageUrl, required this.postedAt, this.viewCount});
}

enum SavedItemType { post, image, video, link }

class SavedItem {
  final String id;
  final String title;
  final String? thumbnailUrl;
  final SavedItemType type;
  final DateTime savedAt;

  SavedItem({required this.id, required this.title, this.thumbnailUrl, required this.type, required this.savedAt});
}

class ProfileDownloadItem {
  final String id;
  final String fileName;
  final String fileExtension;
  final int fileSizeBytes;
  final DateTime downloadedAt;

  ProfileDownloadItem({
    required this.id,
    required this.fileName,
    required this.fileExtension,
    this.fileSizeBytes = 0,
    required this.downloadedAt,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

enum ActivityType { like, comment, follow, mention }

class ActivityItem {
  final String id;
  final ActivityType type;
  final String actorName;
  final String? actorAvatarUrl;
  final String? contextText; // e.g. the post/comment preview
  final DateTime time;
  final bool isRead;

  ActivityItem({
    required this.id,
    required this.type,
    required this.actorName,
    this.actorAvatarUrl,
    this.contextText,
    required this.time,
    this.isRead = false,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String? iconUrl;
  final bool isUnlocked;
  final double progress; // 0.0 - 1.0, only relevant if not yet unlocked
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.iconUrl,
    this.isUnlocked = false,
    this.progress = 0,
    this.unlockedAt,
  });
}