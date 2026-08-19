
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';
import 'personal_chat_screen.dart';
import 'group_chat_screen.dart';
import 'story_viewer_screen.dart';
import 'add_story_screen.dart';
import 'calls_screen.dart';
import 'message_search_screen.dart';

/// Messages Home — top: stories row, below: chat threads list.
///
/// FRONTEND ONLY. [stories] and [threads] are placeholder lists —
/// wire them up to your backend/Firebase later. Empty by default so
/// nothing is hardcoded.
class MessagesHomeScreen extends StatefulWidget {
  final List<StoryItem> stories;
  final List<ChatThread> threads;

  const MessagesHomeScreen({super.key, this.stories = const [], this.threads = const []});

  @override
  State<MessagesHomeScreen> createState() => _MessagesHomeScreenState();
}

class _MessagesHomeScreenState extends State<MessagesHomeScreen> {
  void _openThread(ChatThread thread) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => thread.isGroup
            ? GroupChatScreen(thread: thread, messages: const [])
            : PersonalChatScreen(thread: thread, messages: const []),
      ),
    );
  }

  void _openStory(StoryItem story, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StoryViewerScreen(stories: widget.stories, initialIndex: index)),
    );
  }

  void _openAddStory() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddStoryScreen()));
  }

  void _openCalls() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CallsScreen(callLogs: [])));
  }

  void _openSearch() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessageSearchScreen(threads: widget.threads)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    const Text('Messages', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(onPressed: _openSearch, icon: const Icon(Icons.search, color: Colors.white)),
                    IconButton(onPressed: _openCalls, icon: const Icon(Icons.call_outlined, color: Colors.white)),
                  ],
                ),
              ),

              // ── Stories row ────────────────────────────────────
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _AddStoryBubble(onTap: _openAddStory),
                    ...widget.stories.asMap().entries.map((entry) {
                      final i = entry.key;
                      final story = entry.value;
                      return _StoryBubble(story: story, onTap: () => _openStory(story, i));
                    }),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF2E2E2E), height: 1),

              // ── Chat threads list ──────────────────────────────
              Expanded(
                child: widget.threads.isEmpty
                    ? Center(
                        child: Text('No conversations yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: widget.threads.length,
                        itemBuilder: (context, index) {
                          final thread = widget.threads[index];
                          return ChatThreadTile(thread: thread, onTap: () => _openThread(thread));
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

class _AddStoryBubble extends StatelessWidget {
  final VoidCallback onTap;
  const _AddStoryBubble({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              children: [
                const ChatAvatar(radius: 28),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: kRedColor, shape: BoxShape.circle, border: Border.all(color: kBackgroundColor, width: 2)),
                    child: const Icon(Icons.add, color: Colors.white, size: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Your Story', style: TextStyle(color: Colors.grey.shade400, fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final StoryItem story;
  final VoidCallback onTap;
  const _StoryBubble({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Hero(
              tag: 'story-${story.id}',
              child: ChatAvatar(imageUrl: story.userAvatarUrl, radius: 28, showRing: true, ringSeen: story.isViewed),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 60,
              child: Text(
                story.userName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 10.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}