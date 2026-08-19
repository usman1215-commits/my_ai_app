// Placeholder for search notes screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';
import 'note_widgets.dart';
import 'note_viewer_screen.dart';

/// Search across notes. FRONTEND ONLY — filtering happens locally on
/// [allNotes] for now; swap in a real backend/search call when ready.
class SearchNotesScreen extends StatefulWidget {
  final List<Note> allNotes;

  const SearchNotesScreen({super.key, this.allNotes = const []});

  @override
  State<SearchNotesScreen> createState() => _SearchNotesScreenState();
}

class _SearchNotesScreenState extends State<SearchNotesScreen> {
  final _controller = TextEditingController();
  List<Note> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    // TODO: replace with a real backend search call for large datasets.
    setState(() {
      _results = query.isEmpty
          ? []
          : widget.allNotes.where((n) => n.title.toLowerCase().contains(query.toLowerCase()) || n.content.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(22)),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                autofocus: true,
                                onChanged: _onQueryChanged,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(border: InputBorder.none, hintText: 'Search notes...', hintStyle: TextStyle(color: Colors.grey.shade500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _results.isEmpty
                    ? Center(child: Text(_controller.text.isEmpty ? 'Search your notes' : 'No results found', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
                        itemCount: _results.length,
                        itemBuilder: (context, i) => NoteCard(note: _results[i], onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteViewerScreen(note: _results[i])))),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}