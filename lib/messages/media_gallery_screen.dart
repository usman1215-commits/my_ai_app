import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';

/// Media gallery grid (images/videos shared in a chat).
/// FRONTEND ONLY — [mediaItems] placeholder list.
class MediaGalleryScreen extends StatelessWidget {
  final List<MediaItem> mediaItems;

  const MediaGalleryScreen({super.key, this.mediaItems = const []});

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
                    Text('Media', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: mediaItems.isEmpty
                    ? Center(child: Text('No media shared yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6,
                        ),
                        itemCount: mediaItems.length,
                        itemBuilder: (context, i) {
                          final item = mediaItems[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(color: kFieldColor, child: Image.network(item.url, fit: BoxFit.cover)),
                                if (item.type == MediaType.video)
                                  const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 26)),
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