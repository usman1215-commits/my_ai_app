// Placeholder for safe videos screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden videos grid. FRONTEND ONLY — [videos] placeholder list.
class SafeVideosScreen extends StatelessWidget {
  final List<SafeMediaItem> videos;

  const SafeVideosScreen({super.key, this.videos = const []});

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
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    const Text('Videos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: open device video picker to add to safe folder.
                    }, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: videos.isEmpty
                    ? Center(child: Text('No hidden videos yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
                        itemCount: videos.length,
                        itemBuilder: (context, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: kFieldColor, child: Image.network(videos[i].url, fit: BoxFit.cover)),
                              const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 24)),
                            ],
                          ),
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