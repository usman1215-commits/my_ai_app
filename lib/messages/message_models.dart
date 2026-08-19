/// Shared data models for the Messages module.
/// FRONTEND ONLY — every field here is meant to be populated from
/// your backend/Firebase/API. Nothing in this file is hardcoded data,
/// just the shape of the data.
library;

class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isOnline;

  ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isOnline = false,
  });
}

/// A row in the Messages Home list (1-1 or group).
class ChatThread {
  final String id;
  final String title;
  final String? avatarUrl;
  final bool isGroup;
  final String? lastMessagePreview;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatThread({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.isGroup = false,
    this.lastMessagePreview,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

enum MessageType { text, voice, image, file }

class ChatBubbleMessage {
  final String id;
  final String text;
  final bool fromMe;
  final DateTime time;
  final MessageType type;
  final String? senderName; // used in group chats
  final String? senderAvatarUrl;
  final Duration? voiceDuration; // for voice messages
  final String? mediaUrl; // for image/file messages
  final bool isSeen;

  ChatBubbleMessage({
    required this.id,
    required this.text,
    required this.fromMe,
    required this.time,
    this.type = MessageType.text,
    this.senderName,
    this.senderAvatarUrl,
    this.voiceDuration,
    this.mediaUrl,
    this.isSeen = false,
  });
}

class StoryItem {
  final String id;
  final String userName;
  final String? userAvatarUrl;
  final List<String> storyImageUrls; // one story can have multiple segments
  final bool isViewed;
  final bool isMine;

  StoryItem({
    required this.id,
    required this.userName,
    this.userAvatarUrl,
    this.storyImageUrls = const [],
    this.isViewed = false,
    this.isMine = false,
  });
}

enum CallType { voice, video }
enum CallDirection { incoming, outgoing, missed }

class CallLogItem {
  final String id;
  final String userName;
  final String? userAvatarUrl;
  final CallType type;
  final CallDirection direction;
  final DateTime time;
  final Duration? duration;

  CallLogItem({
    required this.id,
    required this.userName,
    this.userAvatarUrl,
    required this.type,
    required this.direction,
    required this.time,
    this.duration,
  });
}

enum MediaType { image, video }

class MediaItem {
  final String id;
  final String url;
  final MediaType type;
  final DateTime date;

  MediaItem({required this.id, required this.url, required this.type, required this.date});
}

class SharedFileItem {
  final String id;
  final String fileName;
  final String fileExtension;
  final int fileSizeBytes;
  final DateTime sharedDate;
  final String sharedByName;

  SharedFileItem({
    required this.id,
    required this.fileName,
    required this.fileExtension,
    required this.fileSizeBytes,
    required this.sharedDate,
    required this.sharedByName,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}