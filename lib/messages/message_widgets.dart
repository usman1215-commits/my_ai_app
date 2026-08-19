import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';

const kOnlineGreen = Color(0xFF4CAF50);
const kGroupPurple = Color(0xFF7B7BFF);

/// Circular avatar with an optional colored ring (used for stories)
/// and an online-status dot.
class ChatAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showRing;
  final bool ringSeen; // grey ring if the story was already viewed
  final bool showOnlineDot;

  const ChatAvatar({
    super.key,
    this.imageUrl,
    this.radius = 26,
    this.showRing = false,
    this.ringSeen = false,
    this.showOnlineDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: kFieldColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? Icon(Icons.person, color: Colors.white54, size: radius) : null,
    );

    Widget content = avatar;

    if (showRing) {
      content = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: ringSeen
              ? null
              : const LinearGradient(colors: [kRedColor, Color(0xFFFF8A65)]),
          color: ringSeen ? Colors.grey.shade700 : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: kBackgroundColor),
          child: avatar,
        ),
      );
    }

    if (!showOnlineDot) return content;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        content,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: radius * 0.4,
            height: radius * 0.4,
            decoration: BoxDecoration(
              color: kOnlineGreen,
              shape: BoxShape.circle,
              border: Border.all(color: kBackgroundColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single chat thread row on the Messages Home list.
class ChatThreadTile extends StatelessWidget {
  final ChatThread thread;
  final VoidCallback onTap;

  const ChatThreadTile({super.key, required this.thread, required this.onTap});

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m ${time.hour >= 12 ? 'PM' : 'AM'}';
    }
    return '${time.day}/${time.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              ChatAvatar(imageUrl: thread.avatarUrl, showOnlineDot: thread.isOnline),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (thread.isGroup)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(Icons.groups_rounded, color: kGroupPurple, size: 14),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      thread.lastMessagePreview ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: thread.unreadCount > 0 ? Colors.white70 : Colors.grey.shade500,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_formatTime(thread.lastMessageTime), style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  const SizedBox(height: 6),
                  if (thread.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                      child: Text('${thread.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chat bubble supporting text, voice-message, and file/image message types.
class MessageBubble extends StatelessWidget {
  final ChatBubbleMessage message;
  final bool showSenderName; // for group chats

  const MessageBubble({super.key, required this.message, this.showSenderName = false});

  @override
  Widget build(BuildContext context) {
    final isMe = message.fromMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSenderName && !isMe && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 3),
              child: Text(message.senderName!, style: TextStyle(color: Colors.grey.shade400, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: message.type == MessageType.voice
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: isMe ? kRedColor : kFieldColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
            ),
            child: _buildContent(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_formatTime(message.time), style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isSeen ? Icons.done_all : Icons.done,
                    size: 13,
                    color: message.isSeen ? kRedColor : Colors.grey.shade600,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.voice:
        return VoiceMessagePlayer(duration: message.voiceDuration ?? Duration.zero, isMe: message.fromMe);
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: message.mediaUrl != null
              ? Image.network(message.mediaUrl!, width: 180, height: 180, fit: BoxFit.cover)
              : Container(width: 180, height: 180, color: Colors.black26, child: const Icon(Icons.image, color: Colors.white38)),
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Flexible(child: Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 13.5))),
          ],
        );
      case MessageType.text:
        return Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35));
    }
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour >= 12 ? 'PM' : 'AM'}';
  }
}

/// Waveform-style voice message player (visual only — wire up real
/// audio playback later).
class VoiceMessagePlayer extends StatefulWidget {
  final Duration duration;
  final bool isMe;

  const VoiceMessagePlayer({super.key, required this.duration, required this.isMe});

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final barColor = widget.isMe ? Colors.white : Colors.white70;
    final mins = widget.duration.inMinutes;
    final secs = (widget.duration.inSeconds % 60).toString().padLeft(2, '0');

    return SizedBox(
      width: 190,
      child: Row(
        children: [
          GestureDetector(
            // TODO: wire up real audio playback (e.g. just_audio / audioplayers).
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: barColor.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: barColor, size: 18),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 24,
              child: Row(
                children: List.generate(18, (i) {
                  final h = 6.0 + (i % 5) * 3.5;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: h,
                      decoration: BoxDecoration(color: barColor.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(2)),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('$mins:$secs', style: TextStyle(color: barColor, fontSize: 10.5)),
        ],
      ),
    );
  }
}