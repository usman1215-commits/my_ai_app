// Placeholder for note viewer screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';
import 'note_widgets.dart';
import 'note_editor_screen.dart';
import 'checklist_screen.dart';
import 'drawing_screen.dart';
import 'voice_notes_screen.dart';
import 'attachments_screen.dart';

/// Read-only note view with edit/share/delete actions, routing to the
/// right viewer/editor depending on [note.type]. FRONTEND ONLY.
class NoteViewerScreen extends StatelessWidget {
  final Note note;

  const NoteViewerScreen({super.key, required this.note});

  void _edit(BuildContext context) {
    switch (note.type) {
      case NoteType.text:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)));
      case NoteType.checklist:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChecklistScreen(note: note)));
      case NoteType.drawing:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DrawingScreen(note: note)));
      case NoteType.voice:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VoiceNotesScreen()));
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
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: real share sheet.
                    }, icon: const Icon(Icons.share_outlined, color: Colors.white70, size: 20)),
                    IconButton(onPressed: () => _edit(context), icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20)),
                    IconButton(onPressed: () {
                      // TODO: real delete + confirm dialog + backend call.
                      Navigator.of(context).pop();
                    }, icon: const Icon(Icons.delete_outline, color: kRedColor, size: 20)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (note.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: note.category!.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: Text(note.category!.name, style: TextStyle(color: note.category!.color, fontSize: 11)),
                            ),
                          const Spacer(),
                          Text(formatNoteDate(note.updatedAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(note.title.isEmpty ? 'Untitled' : note.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),

                      if (note.type == NoteType.checklist)
                        ...note.checklistItems.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(item.isDone ? Icons.check_box : Icons.check_box_outline_blank, color: item.isDone ? kRedColor : Colors.grey.shade500, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.text,
                                      style: TextStyle(
                                        color: item.isDone ? Colors.grey.shade500 : Colors.white,
                                        fontSize: 14,
                                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      else if (note.type == NoteType.voice)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow, color: kRedColor, size: 28),
                              const SizedBox(width: 12),
                              Text(note.voiceDuration != null ? formatNoteDuration(note.voiceDuration!) : '--:--', style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        )
                      else if (note.type == NoteType.drawing)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 260,
                            width: double.infinity,
                            color: kFieldColor,
                            child: note.drawingImageUrl != null
                                ? Image.network(note.drawingImageUrl!, fit: BoxFit.cover)
                                : Icon(Icons.brush_outlined, color: Colors.grey.shade700, size: 40),
                          ),
                        )
                      else
                        Text(note.content, style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.6)),

                      if (note.attachments.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Attachments (${note.attachments.length})', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AttachmentsScreen(attachments: note.attachments))),
                              child: const Text('View all', style: TextStyle(color: kRedColor, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 30),
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