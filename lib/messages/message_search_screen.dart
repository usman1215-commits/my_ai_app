import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';
import 'personal_chat_screen.dart';
import 'group_chat_screen.dart';

/// Search across chat threads. FRONTEND ONLY — filtering happens
/// locally on [threads] for now; swap in a real backend/search API
/// call inside _onQueryChanged when ready.
class MessageSearchScreen extends StatefulWidget {
  final List<ChatThread> threads;

  const MessageSearchScreen({super.key, this.threads = const []});

  @override
  State<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends State<MessageSearchScreen> {
  final _controller = TextEditingController();
  List<ChatThread> _results = [];

  @override
  void initState() {
    super.initState();
    _results = widget.threads;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    // TODO: replace with a real backend search call for large datasets.
    setState(() {
      _results = query.isEmpty
          ? widget.threads
          : widget.threads.where((t) => t.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _openThread(ChatThread thread) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => thread.isGroup
            ? GroupChatScreen(thread: thread, messages: const [])
            : PersonalChatScreen(thread: thread, messages: const []),
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(22)),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                autofocus: true,
                                onChanged: _onQueryChanged,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(border: InputBorder.none, hintText: 'Search messages...', hintStyle: TextStyle(color: Colors.grey.shade500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _results.isEmpty
                    ? Center(child: Text('No results found', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        itemBuilder: (context, i) => ChatThreadTile(thread: _results[i], onTap: () => _openThread(_results[i])),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}