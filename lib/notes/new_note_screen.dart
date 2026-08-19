import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_editor_screen.dart';
import 'voice_notes_screen.dart';
import 'drawing_screen.dart';
import 'checklist_screen.dart';

/// New Note — pick a note type, then routes to the right editor.
/// FRONTEND ONLY.
class NewNoteScreen extends StatelessWidget {
  const NewNoteScreen({super.key});

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
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('New Note', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: GridView(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.1),
                  children: [
                    _TypeCard(
                      icon: Icons.notes_rounded,
                      label: 'Text Note',
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NoteEditorScreen())),
                    ),
                    _TypeCard(
                      icon: Icons.mic_rounded,
                      label: 'Voice Note',
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const VoiceNotesScreen())),
                    ),
                    _TypeCard(
                      icon: Icons.brush_rounded,
                      label: 'Drawing',
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DrawingScreen())),
                    ),
                    _TypeCard(
                      icon: Icons.checklist_rounded,
                      label: 'Checklist',
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ChecklistScreen())),
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

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TypeCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kRedColor, size: 32),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}