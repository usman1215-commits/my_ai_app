import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Saved — bookmarked posts/images/videos/links.
/// FRONTEND ONLY — [items] placeholder list from your backend.
class SavedScreen extends StatelessWidget {
  final List<SavedItem> items;

  const SavedScreen({super.key, this.items = const []});

  IconData _iconFor(SavedItemType type) {
    switch (type) {
      case SavedItemType.post: return Icons.article_outlined;
      case SavedItemType.image: return Icons.image_outlined;
      case SavedItemType.video: return Icons.videocam_outlined;
      case SavedItemType.link: return Icons.link;
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
                    Text('Saved', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text('Nothing saved yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 48, height: 48,
                                    color: kBackgroundColor,
                                    child: item.thumbnailUrl != null
                                        ? Image.network(item.thumbnailUrl!, fit: BoxFit.cover)
                                        : Icon(_iconFor(item.type), color: Colors.grey.shade600, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
                                ),
                                Icon(Icons.bookmark, color: kRedColor, size: 18),
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