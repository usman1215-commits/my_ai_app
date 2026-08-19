import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';
import 'media_gallery_screen.dart';
import 'shared_files_screen.dart';

/// Profile view for a chat contact — avatar, name, bio, quick
/// actions (call/video/mute/block), and shortcuts into that
/// conversation's media/files. FRONTEND ONLY.
class UserProfileScreen extends StatefulWidget {
  final ChatThread thread;
  final String? bio;

  const UserProfileScreen({super.key, required this.thread, this.bio});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const OzziBackButton(),
                const SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      ChatAvatar(imageUrl: widget.thread.avatarUrl, radius: 48, showOnlineDot: widget.thread.isOnline),
                      const SizedBox(height: 14),
                      Text(widget.thread.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(widget.thread.isOnline ? 'Online' : 'Offline', style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5)),
                      if (widget.bio != null) ...[
                        const SizedBox(height: 10),
                        Text(widget.bio!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionIcon(icon: Icons.call_outlined, label: 'Call', onTap: () {}),
                    _ActionIcon(icon: Icons.videocam_outlined, label: 'Video', onTap: () {}),
                    _ActionIcon(icon: Icons.search, label: 'Search', onTap: () {}),
                    _ActionIcon(
                      icon: _isMuted ? Icons.notifications_off_outlined : Icons.notifications_none,
                      label: _isMuted ? 'Muted' : 'Mute',
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _NavRow(
                  icon: Icons.photo_library_outlined,
                  label: 'Media, Links & Docs',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MediaGalleryScreen())),
                ),
                _NavRow(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Shared Files',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SharedFilesScreen())),
                ),
                _NavRow(icon: Icons.star_border_rounded, label: 'Starred Messages', onTap: () {
                  // TODO: navigate to starred messages screen.
                }),
                _NavRow(icon: Icons.block, label: 'Block User', isDestructive: true, onTap: () {
                  // TODO: call your real block-user API.
                }),
                _NavRow(icon: Icons.report_outlined, label: 'Report', isDestructive: true, onTap: () {
                  // TODO: call your real report API.
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: const BoxDecoration(color: kFieldColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _NavRow({required this.icon, required this.label, this.isDestructive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isDestructive ? kRedColor : Colors.white70, size: 20),
        title: Text(label, style: TextStyle(color: isDestructive ? kRedColor : Colors.white, fontSize: 13.5)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}