
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable story avatar bubble — circular ring (unseen =
/// gradient, seen = grey), label underneath. FRONTEND ONLY.
class StoryCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isViewed;
  final bool showAddBadge;
  final double radius;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.label,
    this.imageUrl,
    this.isViewed = false,
    this.showAddBadge = false,
    this.radius = 28,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: radius * 2.2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isViewed ? null : const LinearGradient(colors: [kRedColor, Color(0xFFFF8A65)]),
                    color: isViewed ? Colors.grey.shade700 : null,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: kBackgroundColor),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: kFieldColor,
                      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                      child: imageUrl == null ? Icon(Icons.person, color: Colors.white54, size: radius) : null,
                    ),
                  ),
                ),
                if (showAddBadge)
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(color: kRedColor, shape: BoxShape.circle, border: Border.all(color: kBackgroundColor, width: 2)),
                      child: const Icon(Icons.add, color: Colors.white, size: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade300, fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}