// Placeholder for safe videos screen.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden videos grid. FRONTEND ONLY — [videos] placeholder list;
/// tapping "+" opens the device video picker right away. Newly
/// picked videos are shown locally (as filename chips) — wire up
/// your real "move to safe" + secure upload API where marked.
class SafeVideosScreen extends StatefulWidget {
  final List<SafeMediaItem> videos;

  const SafeVideosScreen({super.key, this.videos = const []});

  @override
  State<SafeVideosScreen> createState() => _SafeVideosScreenState();
}

class _SafeVideosScreenState extends State<SafeVideosScreen> {
  final List<PlatformFile> _pickedVideos = [];

  Future<void> _pickVideos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    // TODO: upload each picked file to your real secure backend/safe
    // storage here, then refresh [videos] from the backend instead
    // of just holding them in local state.
    setState(() => _pickedVideos.addAll(result.files));
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.videos.length + _pickedVideos.length;

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
                    IconButton(onPressed: _pickVideos, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: totalCount == 0
                    ? Center(child: Text('No hidden videos yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
                        itemCount: totalCount,
                        itemBuilder: (context, i) {
                          if (i < widget.videos.length) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(color: kFieldColor, child: Image.network(widget.videos[i].url, fit: BoxFit.cover)),
                                  const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 24)),
                                ],
                              ),
                            );
                          }
                          final file = _pickedVideos[i - widget.videos.length];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: kFieldColor,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.videocam, color: Colors.white70, size: 22),
                                  const SizedBox(height: 4),
                                  Text(
                                    file.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white70, fontSize: 9),
                                  ),
                                ],
                              ),
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