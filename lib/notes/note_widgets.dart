// Placeholder for reusable note widgets.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';

String formatNoteDuration(Duration d) {
  final m = d.inMinutes;
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

String formatNoteDate(DateTime d) {
  final now = DateTime.now();
  if (d.year == now.year && d.month == now.month && d.day == now.day) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
  }
  return '${d.day}/${d.month}/${d.year}';
}

IconData iconForNoteType(NoteType type) {
  switch (type) {
    case NoteType.text: return Icons.notes_rounded;
    case NoteType.voice: return Icons.mic_rounded;
    case NoteType.drawing: return Icons.brush_rounded;
    case NoteType.checklist: return Icons.checklist_rounded;
  }
}

/// A note card used in the Notes Home grid.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(iconForNoteType(note.type), color: note.category?.color ?? kRedColor, size: 16),
                  const Spacer(),
                  if (note.isPinned) const Icon(Icons.push_pin, color: kRedColor, size: 14),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              if (note.type == NoteType.checklist)
                Text(
                  '${note.checklistItems.where((i) => i.isDone).length}/${note.checklistItems.length} done',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                )
              else if (note.type == NoteType.voice)
                Text(
                  note.voiceDuration != null ? formatNoteDuration(note.voiceDuration!) : 'Voice note',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                )
              else if (note.type == NoteType.drawing)
                Text('Drawing', style: TextStyle(color: Colors.grey.shade500, fontSize: 12))
              else
                Text(
                  note.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5),
                ),
              const Spacer(),
              Text(formatNoteDate(note.updatedAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 10.5)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small rounded chip used for category filters.
class CategoryChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label, this.color, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? kRedColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? c : kFieldColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }
}