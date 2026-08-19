
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable profile row/card — avatar, name, subtitle,
/// optional trailing action. Used anywhere a person needs to be
/// listed (contacts, search results, member lists). FRONTEND ONLY.
class ProfileCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final bool isOnline;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.isOnline = false,
    this.trailing,
    required this.onTap,
  });

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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: kFieldColor,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null ? const Icon(Icons.person, color: Colors.white54, size: 22) : null,
                  ),
                  isOnline
                      ? Positioned(
                          right: 0, bottom: 0,
                          child: Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, border: Border.all(color: kBackgroundColor, width: 2)),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle != null
                        ? Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 12))
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              trailing != null ? trailing! : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}