// Placeholder for safe photos screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden photos grid. FRONTEND ONLY — [photos] placeholder list;
/// wire up a real "move to safe" picker + secure storage later.
class SafePhotosScreen extends StatelessWidget {
  final List<SafeMediaItem> photos;

  const SafePhotosScreen({super.key, this.photos = const []});

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
                    const Text('Photos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: open device photo picker to add to safe folder.
                    }, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: photos.isEmpty
                    ? Center(child: Text('No hidden photos yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
                        itemCount: photos.length,
                        itemBuilder: (context, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(color: kFieldColor, child: Image.network(photos[i].url, fit: BoxFit.cover)),
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