import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/chat_message_list.dart';
import 'chat_history_screen.dart';
import 'ai_settings_screen.dart';
import 'voice_chat_screen.dart';

const _imageExtensions = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'};

class OzziScreen extends StatefulWidget {
  /// Pass the logged-in user's avatar URL from your backend once
  /// available, e.g. OzziScreen(profileImageUrl: user.avatarUrl).
  final String? profileImageUrl;

  const OzziScreen({super.key, this.profileImageUrl});

  @override
  State<OzziScreen> createState() => _OzziScreenState();
}

class _OzziScreenState extends State<OzziScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hey! I\'m Ozzi, your personal AI assistant 👋', fromUser: false),
    ChatMessage(text: 'How can I help you today?', fromUser: false),
  ];
  
  bool _isTemporaryChat = false;

  void _openChatHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatHistoryScreen(
          sessions: const [], // TODO: pass real saved sessions from backend/DB.
          onNewChat: () {
            Navigator.of(context).pop();
            setState(() {
              _messages.clear();
              _isTemporaryChat = false;
            });
          },
          onTemporaryChat: () {
            Navigator.of(context).pop();
            setState(() {
              _messages.clear();
              _isTemporaryChat = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Temporary chat started — won\'t be saved')),
            );
          },
          onOpenSession: (session) {
            // TODO: load real messages for this session from backend/DB.
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _openAiSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
    );
  }

  void _openVoiceChat() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VoiceChatScreen()),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text.trim(), fromUser: true));
    });
    // TODO: replace this with your real AI backend call.
    // Below is just a placeholder so the chat visibly responds.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: "Got it — I'll help with that.", fromUser: false));
      });
    });
  }

  /// Opens the device's file/photo picker. Whatever the user selects
  /// (image or document) is added straight into the chat as a
  /// message from the user, then handed off for the AI to see.
  ///
  /// TODO: once your AI backend is connected, upload the picked file
  /// (fileBytes on web, or the file at filePath on mobile/desktop)
  /// alongside the message so the AI can actually read/view it.
  Future<void> _pickAndAddFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: kIsWeb, // web needs raw bytes; mobile/desktop can use the file path
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = (file.extension ?? '').toLowerCase();
    final isImage = _imageExtensions.contains(ext);

    setState(() {
      _messages.add(ChatMessage(
        text: file.name,
        fromUser: true,
        fileName: file.name,
        filePath: kIsWeb ? null : file.path,
        fileBytes: file.bytes,
        isImage: isImage,
      ));
    });

    // TODO: replace with your real AI backend call, sending the file along.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: "Got your file — I'll take a look.", fromUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              // ── Top: menu, settings icons ─────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _openChatHistory,
                          child: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                    if (_isTemporaryChat)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kFieldColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.visibility_off_outlined, color: kRedColor, size: 13),
                            const SizedBox(width: 4),
                            Text('Temporary', style: TextStyle(color: Colors.grey.shade300, fontSize: 11)),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: _openAiSettings,
                      child: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),

              // ── Profile, date, weather ────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                // Weather is UI-only for now — pass activeWeather &
                // temperatureText once your backend/API gives real data.
                // e.g. HomeTopBar(activeWeather: WeatherIcon.cloud, temperatureText: '13°C')
                child: HomeTopBar(profileImageUrl: widget.profileImageUrl),
              ),

              // ── Middle: chat messages, grows + scrolls ───────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ChatMessageList(messages: _messages),
                ),
              ),

              // ── Input row: text field + + button ─────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: _ChatInputRow(
                  onSend: _sendMessage,
                  onAddPressed: _pickAndAddFile,
                  onMicPressed: _openVoiceChat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInputRow extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onAddPressed;
  final VoidCallback onMicPressed;

  const _ChatInputRow({required this.onSend, required this.onAddPressed, required this.onMicPressed});

  @override
  State<_ChatInputRow> createState() => _ChatInputRowState();
}

class _ChatInputRowState extends State<_ChatInputRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // + button — opens the device file/photo picker.
        GestureDetector(
          onTap: widget.onAddPressed,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: kFieldColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: kRedColor, size: 24),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: kFieldColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Message Ozzi...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: widget.onMicPressed,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: kFieldColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _handleSend,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: kRedColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}