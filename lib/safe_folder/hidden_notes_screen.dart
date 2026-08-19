// Placeholder for hidden notes screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';
import 'safe_folder_widgets.dart';

/// Hidden Notes — private notes kept inside the safe folder.
/// FRONTEND ONLY — [notes] placeholder list.
class HiddenNotesScreen extends StatelessWidget {
  final List<HiddenNoteItem> notes;

  const HiddenNotesScreen({super.key, this.notes = const []});

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
                    const Text('Hidden Notes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: open new hidden-note editor, save to secure storage.
                    }, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: notes.isEmpty
                    ? Center(child: Text('No hidden notes yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: notes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final n = notes[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.title.isEmpty ? 'Untitled' : n.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(n.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                                const SizedBox(height: 6),
                                Text(formatSafeDate(n.updatedAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 10.5)),
                              ],
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