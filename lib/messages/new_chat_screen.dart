import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';
import 'personal_chat_screen.dart';

/// New Chat — pick a user (with search) to start a 1-on-1 conversation.
/// FRONTEND ONLY — [allUsers] is a placeholder list; wire this up to
/// your real backend/contacts/user-search API. Tapping a user opens
/// [PersonalChatScreen] with a fresh [ChatThread] built from that user
/// — replace [_startChatWith] with your real "get or create thread"
/// backend call once available.
class NewChatScreen extends StatefulWidget {
  final List<ChatUser> allUsers;

  const NewChatScreen({super.key, this.allUsers = const []});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _controller = TextEditingController();
  List<ChatUser> _results = [];

  @override
  void initState() {
    super.initState();
    _results = widget.allUsers;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    // TODO: replace with a real backend/user-search API call for large datasets.
    setState(() {
      _results = query.isEmpty
          ? widget.allUsers
          : widget.allUsers.where((u) => u.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _startChatWith(ChatUser user) {
    // TODO: replace with your real "get or create chat thread" backend
    // call, then navigate using the thread it returns.
    final thread = ChatThread(
      id: user.id,
      title: user.name,
      avatarUrl: user.avatarUrl,
      isOnline: user.isOnline,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PersonalChatScreen(thread: thread, messages: const [])),
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
                    const Text('New Chat', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'Search users...', hintStyle: TextStyle(color: Colors.grey.shade500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _results.isEmpty
                    ? Center(child: Text(widget.allUsers.isEmpty ? 'No users found' : 'No results found', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        itemBuilder: (context, i) {
                          final user = _results[i];
                          return ProfileCardCompat(user: user, onTap: () => _startChatWith(user));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin adapter row so this screen doesn't depend on a generic
/// ProfileCard widget elsewhere — keeps this file self-contained.
class ProfileCardCompat extends StatelessWidget {
  final ChatUser user;
  final VoidCallback onTap;

  const ProfileCardCompat({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              ChatAvatar(imageUrl: user.avatarUrl, showOnlineDot: user.isOnline),
              const SizedBox(width: 14),
              Expanded(
                child: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}