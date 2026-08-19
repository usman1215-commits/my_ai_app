// Placeholder for note editor screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';
import 'attachments_screen.dart';

/// Text note editor — title + content + attachments shortcut.
/// FRONTEND ONLY — [note] passed in for editing an existing note
/// (null = creating a new one). Wire up real save to your backend.
class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    // TODO: save this note (title, content, isPinned) to your real
    // backend/local database here.
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
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const Spacer(),
                    IconButton(
                      onPressed: () => setState(() => _isPinned = !_isPinned),
                      icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: _isPinned ? kRedColor : Colors.white70, size: 20),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AttachmentsScreen())),
                      icon: const Icon(Icons.attach_file, color: Colors.white70, size: 20),
                    ),
                    TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(border: InputBorder.none, hintText: 'Title', hintStyle: TextStyle(color: Colors.grey.shade600)),
                      ),
                      const Divider(color: Color(0xFF2E2E2E)),
                      Expanded(
                        child: TextField(
                          controller: _contentController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.5),
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'Start typing...', hintStyle: TextStyle(color: Colors.grey.shade600)),
                        ),
                      ),
                    ],
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