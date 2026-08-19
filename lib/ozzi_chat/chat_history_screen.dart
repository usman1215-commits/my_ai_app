import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Placeholder model for a saved chat session.
/// Replace this list's source with real data from your backend/DB later.
class ChatSession {
  final String id;
  final String title;
  final DateTime lastUpdated;

  ChatSession({required this.id, required this.title, required this.lastUpdated});
}

/// Opened via the 3-line (hamburger) icon on Home.
/// Shows past chat sessions + a "Temporary Chat" quick action.
///
/// FRONTEND ONLY — [sessions] is passed in as a placeholder list.
/// Wire this up to your real chat history source later.
class ChatHistoryScreen extends StatelessWidget {
  final List<ChatSession> sessions;
  final VoidCallback onNewChat;
  final VoidCallback onTemporaryChat;
  final ValueChanged<ChatSession> onOpenSession;

  const ChatHistoryScreen({
    super.key,
    this.sessions = const [],
    required this.onNewChat,
    required this.onTemporaryChat,
    required this.onOpenSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    const Text(
                      'Chats',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    _ActionRow(
                      icon: Icons.add_circle_outline,
                      label: 'New Chat',
                      onTap: onNewChat,
                    ),
                    const SizedBox(height: 10),
                    _ActionRow(
                      icon: Icons.visibility_off_outlined,
                      label: 'Temporary Chat',
                      subtitle: "Won't be saved to history",
                      onTap: onTemporaryChat,
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Recent', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              ),

              // Chat history list — placeholder data source.
              Expanded(
                child: sessions.isEmpty
                    ? Center(
                        child: Text(
                          'No past chats yet',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final s = sessions[index];
                          return _ChatHistoryTile(
                            session: s,
                            onTap: () => onOpenSession(s),
                          );
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

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _ActionRow({required this.icon, required this.label, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: kRedColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    if (subtitle != null)
                      Text(subtitle!, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
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

class _ChatHistoryTile extends StatelessWidget {
  final ChatSession session;
  final VoidCallback onTap;

  const _ChatHistoryTile({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: kFieldColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}