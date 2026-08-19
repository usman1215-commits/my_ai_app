// Placeholder for safe folder models.
/// Shared data models for the Safe Folder module.
/// FRONTEND ONLY — every field is meant to be populated from your
/// backend/local encrypted storage. Nothing here is hardcoded data,
/// just the shape of the data.
library;

enum SafeMediaType { photo, video, document }

class SafeMediaItem {
  final String id;
  final String url;
  final SafeMediaType type;
  final String? fileName;
  final DateTime addedAt;

  SafeMediaItem({
    required this.id,
    required this.url,
    required this.type,
    this.fileName,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

class PasswordEntry {
  final String id;
  final String siteName;
  final String username;
  final String password; // should arrive already-decrypted from a secure backend call
  final String? siteIconUrl;
  final String? notes;

  PasswordEntry({
    required this.id,
    required this.siteName,
    required this.username,
    required this.password,
    this.siteIconUrl,
    this.notes,
  });
}

class HiddenNoteItem {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  HiddenNoteItem({
    required this.id,
    required this.title,
    this.content = '',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
}

class HiddenAppEntry {
  final String id;
  final String appName;
  final String? iconUrl;
  final bool isHidden;

  HiddenAppEntry({
    required this.id,
    required this.appName,
    this.iconUrl,
    this.isHidden = false,
  });
}

enum RecycleItemType { photo, video, document, note }

class RecycleBinItem {
  final String id;
  final String name;
  final RecycleItemType type;
  final String? thumbnailUrl;
  final DateTime deletedAt;
  final int daysUntilPermanentDelete;

  RecycleBinItem({
    required this.id,
    required this.name,
    required this.type,
    this.thumbnailUrl,
    DateTime? deletedAt,
    this.daysUntilPermanentDelete = 30,
  }) : deletedAt = deletedAt ?? DateTime.now();
}