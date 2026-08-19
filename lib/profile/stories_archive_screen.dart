import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Stories Archive — grid of past stories. FRONTEND ONLY —
/// [stories] placeholder list from your backend.
class StoriesArchiveScreen extends StatelessWidget {
  final List<StoryArchiveItem> stories;

  const StoriesArchiveScreen({super.key, this.stories = const []});

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
                    Text('Stories Archive', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: stories.isEmpty
                    ? Center(child: Text('No archived stories yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 0.65),
                        itemCount: stories.length,
                        itemBuilder: (context, i) {
                          final s = stories[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(color: kFieldColor, child: Image.network(s.imageUrl, fit: BoxFit.cover)),
                                if (s.viewCount != null)
                                  Positioned(
                                    left: 6, bottom: 6,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.visibility, color: Colors.white70, size: 11),
                                        const SizedBox(width: 3),
                                        Text('${s.viewCount}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                      ],
                                    ),
                                  ),
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