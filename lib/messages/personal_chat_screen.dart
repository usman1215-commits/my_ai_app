import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';
import 'user_profile_screen.dart';
import 'calls_screen.dart';

/// 1-on-1 chat screen. FRONTEND ONLY — [messages] is a placeholder
/// list; wire it up to your backend/socket connection later.
class PersonalChatScreen extends StatefulWidget {
  final ChatThread thread;
  final List<ChatBubbleMessage> messages;

  const PersonalChatScreen({super.key, required this.thread, this.messages = const []});

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  late List<ChatBubbleMessage> _messages;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.messages);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    // TODO: send via your real backend/socket, then append the confirmed message.
    setState(() {
      _messages.add(ChatBubbleMessage(id: DateTime.now().toString(), text: text, fromMe: true, time: DateTime.now()));
    });
    _inputController.clear();
  }

  void _openProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserProfileScreen(thread: widget.thread)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              _ChatAppBar(thread: widget.thread, onProfileTap: _openProfile),
              Expanded(
                child: _messages.isEmpty
                    ? Center(child: Text('No messages yet — say hi 👋', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: MessageBubble(message: _messages[i]),
                        ),
                      ),
              ),
              _ChatInputBar(controller: _inputController, onSend: _send),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final ChatThread thread;
  final VoidCallback onProfileTap;

  const _ChatAppBar({required this.thread, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      child: Row(
        children: [
          const OzziBackButton(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfileTap,
            child: Row(
              children: [
                ChatAvatar(imageUrl: thread.avatarUrl, radius: 19, showOnlineDot: thread.isOnline),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(thread.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(thread.isOnline ? 'Online' : 'Offline', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CallsScreen(callLogs: []))),
            icon: const Icon(Icons.call_outlined, color: Colors.white, size: 21),
          ),
          IconButton(
            onPressed: () {
              // TODO: start video call.
            },
            icon: const Icon(Icons.videocam_outlined, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: open attachment picker (gallery/file/camera).
            },
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(color: kFieldColor, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: kRedColor, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: hold-to-record voice message.
            },
            onLongPress: () {},
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(color: kFieldColor, shape: BoxShape.circle),
              child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 21),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}