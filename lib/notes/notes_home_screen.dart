// Placeholder for notes home screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';
import 'note_widgets.dart';
import 'new_note_screen.dart';
import 'note_viewer_screen.dart';
import 'categories_screen.dart';
import 'search_notes_screen.dart';

/// Notes Home — category filter row + grid of notes + FAB to create new.
/// FRONTEND ONLY — [notes] and [categories] are placeholder lists from
/// your backend/local database.
class NotesHomeScreen extends StatefulWidget {
  final List<Note> notes;
  final List<NoteCategory> categories;

  const NotesHomeScreen({super.key, this.notes = const [], this.categories = const []});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  String? _selectedCategoryId;

  List<Note> get _filteredNotes {
    if (_selectedCategoryId == null) return widget.notes;
    return widget.notes.where((n) => n.category?.id == _selectedCategoryId).toList();
  }

  void _openNote(Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteViewerScreen(note: note)));
  }

  void _createNote() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewNoteScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final notes = _filteredNotes;
    final pinned = notes.where((n) => n.isPinned).toList();
    final others = notes.where((n) => !n.isPinned).toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        const Text('Notes', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchNotesScreen(allNotes: widget.notes))),
                          icon: const Icon(Icons.search, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoriesScreen(categories: widget.categories))),
                          icon: const Icon(Icons.category_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  if (widget.categories.isNotEmpty)
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          CategoryChip(label: 'All', isSelected: _selectedCategoryId == null, onTap: () => setState(() => _selectedCategoryId = null)),
                          ...widget.categories.map((c) => CategoryChip(
                                label: c.name,
                                color: c.color,
                                isSelected: _selectedCategoryId == c.id,
                                onTap: () => setState(() => _selectedCategoryId = c.id),
                              )),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: notes.isEmpty
                        ? Center(child: Text('No notes yet — tap + to create one', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (pinned.isNotEmpty) ...[
                                  Text('Pinned', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  _grid(pinned),
                                  const SizedBox(height: 16),
                                ],
                                if (others.isNotEmpty) ...[
                                  Text('All Notes', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  _grid(others),
                                ],
                              ],
                            ),
                          ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: GestureDetector(
                  onTap: _createNote,
                  child: Container(
                    width: 56, height: 56,
                    decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid(List<Note> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
      itemCount: items.length,
      itemBuilder: (context, i) => NoteCard(note: items[i], onTap: () => _openNote(items[i])),
    );
  }
}