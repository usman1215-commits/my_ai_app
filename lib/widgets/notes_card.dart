
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable note card — used anywhere a note preview grid is
/// needed. Not tied to the notes module's own models. FRONTEND ONLY.
class NotesCard extends StatelessWidget {
  final String title;
  final String? preview;
  final IconData typeIcon;
  final Color? accentColor;
  final bool isPinned;
  final String? footerText;
  final VoidCallback onTap;

  const NotesCard({
    super.key,
    required this.title,
    this.preview,
    this.typeIcon = Icons.notes_rounded,
    this.accentColor,
    this.isPinned = false,
    this.footerText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(typeIcon, color: accentColor ?? kRedColor, size: 15),
                  const Spacer(),
                  if (isPinned) const Icon(Icons.push_pin, color: kRedColor, size: 13),
                ],
              ),
              const SizedBox(height: 8),
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700)),
              if (preview != null) ...[
                const SizedBox(height: 4),
                Text(preview!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
              const Spacer(),
              if (footerText != null)
                Text(footerText!, style: TextStyle(color: Colors.grey.shade600, fontSize: 10.5)),
            ],
          ),
        ),
      ),
    );
  }
}