import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Activity — notifications feed (likes, comments, follows, mentions).
/// FRONTEND ONLY — [activities] placeholder list.
class ActivityScreen extends StatelessWidget {
  final List<ActivityItem> activities;

  const ActivityScreen({super.key, this.activities = const []});

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.like: return Icons.favorite;
      case ActivityType.comment: return Icons.chat_bubble;
      case ActivityType.follow: return Icons.person_add;
      case ActivityType.mention: return Icons.alternate_email;
    }
  }

  String _verbFor(ActivityType type) {
    switch (type) {
      case ActivityType.like: return 'liked your post';
      case ActivityType.comment: return 'commented on your post';
      case ActivityType.follow: return 'started following you';
      case ActivityType.mention: return 'mentioned you';
    }
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
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('Activity', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: activities.isEmpty
                    ? Center(child: Text('No activity yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: activities.length,
                        itemBuilder: (context, i) {
                          final a = activities[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: kFieldColor,
                                      backgroundImage: a.actorAvatarUrl != null ? NetworkImage(a.actorAvatarUrl!) : null,
                                      child: a.actorAvatarUrl == null ? const Icon(Icons.person, color: Colors.white54, size: 18) : null,
                                    ),
                                    Positioned(
                                      right: -2, bottom: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                                        child: Icon(_iconFor(a.type), color: Colors.white, size: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 13, height: 1.4),
                                      children: [
                                        TextSpan(text: a.actorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                        TextSpan(text: ' ${_verbFor(a.type)}', style: TextStyle(color: Colors.grey.shade400)),
                                        if (a.contextText != null)
                                          TextSpan(text: ' "${a.contextText}"', style: TextStyle(color: Colors.grey.shade500)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!a.isRead)
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle)),
                              ],
                            ),
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