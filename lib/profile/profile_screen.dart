import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';
import 'edit_profile_screen.dart';
import 'stories_archive_screen.dart';
import 'saved_screen.dart';
import 'profile_downloads_screen.dart';
import 'activity_screen.dart';
import 'achievements_screen.dart';

/// Profile — header (avatar/name/bio/stats), Edit Profile button, and
/// a menu into Stories Archive, Saved, Downloads, Activity, Achievements.
/// FRONTEND ONLY — [profile] is a placeholder; wire up to your
/// backend/auth user data.
class ProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileScreen({super.key, required this.profile});

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
                    const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: kFieldColor,
                        backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                        child: profile.avatarUrl == null ? const Icon(Icons.person, color: Colors.white54, size: 40) : null,
                      ),
                      const SizedBox(height: 12),
                      Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
                      Text('@${profile.username}', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      if (profile.bio != null) ...[
                        const SizedBox(height: 10),
                        Text(profile.bio!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.4)),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatItem(label: 'Posts', value: profile.postsCount),
                          _StatDivider(),
                          _StatItem(label: 'Followers', value: profile.followersCount),
                          _StatDivider(),
                          _StatItem(label: 'Following', value: profile.followingCount),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kRedColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Edit Profile', style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _MenuRow(icon: Icons.auto_stories_outlined, label: 'Stories Archive', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoriesArchiveScreen()))),
                      _MenuRow(icon: Icons.bookmark_border, label: 'Saved', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()))),
                      _MenuRow(icon: Icons.download_outlined, label: 'Downloads', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileDownloadsScreen()))),
                      _MenuRow(icon: Icons.notifications_none, label: 'Activity', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActivityScreen()))),
                      _MenuRow(icon: Icons.emoji_events_outlined, label: 'Achievements', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AchievementsScreen()))),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int? value;
  const _StatItem({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value?.toString() ?? '--', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, margin: const EdgeInsets.symmetric(horizontal: 22), color: Colors.grey.shade800);
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: kRedColor, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}