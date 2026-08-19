
import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';

/// Full-screen story viewer with segmented progress bars that
/// auto-advance. FRONTEND ONLY — [stories] passed in from wherever
/// you load them (backend/Firebase).
class StoryViewerScreen extends StatefulWidget {
  final List<StoryItem> stories;
  final int initialIndex;

  const StoryViewerScreen({super.key, required this.stories, this.initialIndex = 0});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late int _storyIndex;
  int _segmentIndex = 0;
  double _progress = 0;
  Timer? _timer;
  static const _segmentDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _storyIndex = widget.initialIndex;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      setState(() {
        _progress += 50 / _segmentDuration.inMilliseconds;
        if (_progress >= 1) _nextSegment();
      });
    });
  }

  void _nextSegment() {
    final segments = widget.stories.isEmpty ? 1 : widget.stories[_storyIndex].storyImageUrls.length.clamp(1, 999);
    if (_segmentIndex < segments - 1) {
      setState(() => _segmentIndex++);
      _startTimer();
    } else {
      _nextStory();
    }
  }

  void _nextStory() {
    if (_storyIndex < widget.stories.length - 1) {
      setState(() {
        _storyIndex++;
        _segmentIndex = 0;
      });
      _startTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prevStory() {
    if (_storyIndex > 0) {
      setState(() {
        _storyIndex--;
        _segmentIndex = 0;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('No stories to show', style: TextStyle(color: Colors.grey.shade500)),
        ),
      );
    }

    final story = widget.stories[_storyIndex];
    final segments = story.storyImageUrls.isEmpty ? 1 : story.storyImageUrls.length;
    final imageUrl = story.storyImageUrls.isNotEmpty ? story.storyImageUrls[_segmentIndex] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PhoneFrame(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTapUp: (details) {
            final w = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < w / 3) {
              _prevStory();
            } else {
              _nextSegment();
            }
          },
          onLongPress: () => _timer?.cancel(),
          onLongPressUp: () => _startTimer(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: kFieldColor, child: const Icon(Icons.image, color: Colors.white24, size: 60)),

              // Top gradient for readability
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black54, Colors.transparent]),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(segments, (i) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: i < _segmentIndex ? 1 : (i == _segmentIndex ? _progress.clamp(0, 1) : 0),
                                child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'story-${story.id}',
                            child: ChatAvatar(imageUrl: story.userAvatarUrl, radius: 16),
                          ),
                          const SizedBox(width: 10),
                          Text(story.userName, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white)),
                        ],
                      ),
                    ),
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