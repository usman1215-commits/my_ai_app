import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';

/// Group chat — same base as personal chat but shows sender name
/// above each incoming bubble, and a member-count subtitle.
/// FRONTEND ONLY — [messages] is a placeholder list.
class GroupChatScreen extends StatefulWidget {
  final ChatThread thread;
  final List<ChatBubbleMessage> messages;
  final int memberCount;

  const GroupChatScreen({
    super.key,
    required this.thread,
    this.messages = const [],
    this.memberCount = 0,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late List<ChatBubbleMessage> _messages;
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.messages);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    // TODO: send via your real backend/socket.
    setState(() {
      _messages.add(ChatBubbleMessage(id: DateTime.now().toString(), text: text, fromMe: true, time: DateTime.now()));
    });
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 8),
                    ChatAvatar(imageUrl: widget.thread.avatarUrl, radius: 19),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.thread.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        Text('${widget.memberCount} members', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: Colors.white, size: 21)),
                  ],
                ),
              ),
              Expanded(
                child: _messages.isEmpty
                    ? Center(child: Text('No messages yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: MessageBubble(message: _messages[i], showSenderName: true),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 44),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(22)),
                        child: TextField(
                          controller: _inputController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'Message...', hintStyle: TextStyle(color: Colors.grey.shade500)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _send,
                      child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle), child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}