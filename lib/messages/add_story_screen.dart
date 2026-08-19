import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Add Story screen — pick from camera/gallery, then caption + post.
/// FRONTEND ONLY — [pickedImagePath] is local UI state; wire up real
/// image_picker / camera plugin and upload logic later.
class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  String? _pickedImagePath;
  final _captionController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _pickFromCamera() {
    // TODO: integrate camera plugin (e.g. image_picker ImageSource.camera).
  }

  void _pickFromGallery() {
    // TODO: integrate gallery picker (e.g. image_picker ImageSource.gallery).
  }

  Future<void> _postStory() async {
    setState(() => _isPosting = true);
    // TODO: upload image + caption to your backend/Firebase storage.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isPosting = false);
    Navigator.of(context).pop();
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
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    const Text('Add Story', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (_pickedImagePath != null)
                      TextButton(
                        onPressed: _isPosting ? null : _postStory,
                        child: Text(_isPosting ? 'Posting...' : 'Share', style: const TextStyle(color: kRedColor, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  child: _pickedImagePath == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade600, size: 48),
                              const SizedBox(height: 12),
                              Text('Pick a photo to share', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                            ],
                          ),
                        )
                      : Image.network(_pickedImagePath!, fit: BoxFit.cover),
                ),
              ),
              if (_pickedImagePath != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: OzziTextField(icon: Icons.edit_outlined, hint: 'Add a caption...', controller: _captionController),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _SourceButton(icon: Icons.camera_alt_outlined, label: 'Camera', onTap: _pickFromCamera),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SourceButton(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: _pickFromGallery),
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

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.5)),
            ],
          ),
        ),
      ),
    );
  }
}