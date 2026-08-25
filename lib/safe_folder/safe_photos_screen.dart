// Placeholder for safe photos screen.
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden photos grid. FRONTEND ONLY — [photos] placeholder list;
/// tapping "+" opens the device photo picker right away. Newly
/// picked images are shown locally so the UI feels real — wire up
/// your real "move to safe" + secure upload API where marked.
class SafePhotosScreen extends StatefulWidget {
  final List<SafeMediaItem> photos;

  const SafePhotosScreen({super.key, this.photos = const []});

  @override
  State<SafePhotosScreen> createState() => _SafePhotosScreenState();
}

class _SafePhotosScreenState extends State<SafePhotosScreen> {
  final List<PlatformFile> _pickedPhotos = [];

  Future<void> _pickPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    // TODO: upload each picked file to your real secure backend/safe
    // storage here, then refresh [photos] from the backend instead
    // of just holding them in local state.
    setState(() => _pickedPhotos.addAll(result.files));
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.photos.length + _pickedPhotos.length;

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
                    IconButton(onPressed: _pickPhotos, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: totalCount == 0
                    ? Center(child: Text('No hidden photos yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
                        itemCount: totalCount,
                        itemBuilder: (context, i) {
                          if (i < widget.photos.length) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(color: kFieldColor, child: Image.network(widget.photos[i].url, fit: BoxFit.cover)),
                            );
                          }
                          final file = _pickedPhotos[i - widget.photos.length];
                          final Uint8List? bytes = file.bytes;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: kFieldColor,
                              child: bytes != null
                                  ? Image.memory(bytes, fit: BoxFit.cover)
                                  : (!kIsWeb && file.path != null
                                      ? Image.file(File(file.path!), fit: BoxFit.cover)
                                      : const Icon(Icons.image, color: Colors.white24)),
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