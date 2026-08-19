import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Achievements — unlocked & in-progress badges.
/// FRONTEND ONLY — [achievements] placeholder list.
class AchievementsScreen extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsScreen({super.key, this.achievements = const []});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();

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
                    Text('Achievements', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: achievements.isEmpty
                    ? Center(child: Text('No achievements yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        children: [
                          if (unlocked.isNotEmpty) ...[
                            Text('Unlocked (${unlocked.length})', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            ...unlocked.map((a) => _AchievementTile(achievement: a)),
                            const SizedBox(height: 16),
                          ],
                          if (locked.isNotEmpty) ...[
                            Text('In Progress (${locked.length})', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            ...locked.map((a) => _AchievementTile(achievement: a)),
                          ],
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

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: achievement.isUnlocked ? kRedColor.withValues(alpha: 0.15) : Colors.grey.shade800,
            ),
            child: Icon(
              Icons.emoji_events,
              color: achievement.isUnlocked ? kRedColor : Colors.grey.shade600,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(achievement.title, style: TextStyle(color: achievement.isUnlocked ? Colors.white : Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(achievement.description, style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
                if (!achievement.isUnlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: achievement.progress.clamp(0.0, 1.0), minHeight: 5, backgroundColor: Colors.grey.shade800, valueColor: const AlwaysStoppedAnimation(kRedColor)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}