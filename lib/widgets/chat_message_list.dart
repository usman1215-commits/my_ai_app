import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

class ChatMessage {
  final String text;
  final bool fromUser; // false = AI (Ozzi) sent it
  final DateTime time;

  /// Set when this message is an attached file/photo (from the "+"
  /// picker). [filePath] is the picked file's local path (not
  /// usable on web — see [fileBytes]), [fileBytes] is the raw bytes
  /// (used for showing image previews on web where paths aren't
  /// available). [isImage] controls whether it renders as an image
  /// preview or a generic file chip.
  final String? fileName;
  final String? filePath;
  final Uint8List? fileBytes;
  final bool isImage;

  ChatMessage({
    required this.text,
    required this.fromUser,
    DateTime? time,
    this.fileName,
    this.filePath,
    this.fileBytes,
    this.isImage = false,
  }) : time = time ?? DateTime.now();

  bool get hasAttachment => fileName != null;
}

/// Scrollable list of chat bubbles. New messages get appended to
/// [messages] from outside (e.g. after your AI backend responds),
/// and the list auto-scrolls to the newest one. Once messages
/// overflow the visible height, it becomes scrollable automatically
/// (ListView handles that natively — no extra logic needed).
class ChatMessageList extends StatefulWidget {
  final List<ChatMessage> messages;

  const ChatMessageList({super.key, required this.messages});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      // New message arrived — scroll to the bottom after the frame builds.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          'Say hi to Ozzi to get started',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];
        return _ChatBubble(message: msg);
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.fromUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: message.hasAttachment && message.isImage
            ? const EdgeInsets.all(6)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? kRedColor : kFieldColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: message.hasAttachment ? _buildAttachment(context) : _buildText(),
      ),
    );
  }

  Widget _buildText() {
    return Text(
      message.text,
      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
    );
  }

  Widget _buildAttachment(BuildContext context) {
    if (message.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: message.fileBytes != null
            ? Image.memory(message.fileBytes!, width: 180, height: 180, fit: BoxFit.cover)
            : (!kIsWeb && message.filePath != null
                ? Image.file(File(message.filePath!), width: 180, height: 180, fit: BoxFit.cover)
                : Container(width: 180, height: 180, color: Colors.black26, child: const Icon(Icons.image, color: Colors.white38))),
      );
    }

    // Generic file chip (documents, PDFs, etc).
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.insert_drive_file_outlined, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            message.fileName ?? 'File',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
          ),
        ),
      ],
    );
  }
}