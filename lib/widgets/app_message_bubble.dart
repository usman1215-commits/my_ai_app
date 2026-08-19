
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable message bubble (user-side or other-side, text
/// only). For voice/image/file message types, see the more
/// specialized bubble in the Messages module. FRONTEND ONLY.
class AppMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? time;
  final bool isSeen;
  final String? senderName;

  const AppMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.time,
    this.isSeen = false,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 3),
              child: Text(senderName!, style: TextStyle(color: Colors.grey.shade400, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: isMe ? kRedColor : kFieldColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35)),
          ),
          if (time != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time!, style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(isSeen ? Icons.done_all : Icons.done, size: 13, color: isSeen ? kRedColor : Colors.grey.shade600),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}