import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'music_models.dart';
import 'music_widgets.dart';
import 'music_player_state.dart';

/// Search screen — search bar + genre grid (browsing) + results.
/// FRONTEND ONLY — [genres] and search filtering are placeholders;
/// wire up a real backend/search API in [_onQueryChanged].
class MusicSearchScreen extends StatefulWidget {
  final List<Song> allSongs;
  final List<String> genres;

  const MusicSearchScreen({super.key, this.allSongs = const [], this.genres = const []});

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  final _controller = TextEditingController();
  List<Song> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    // TODO: replace with a real backend/search API call.
    setState(() {
      _results = query.isEmpty
          ? []
          : widget.allSongs.where((s) => s.title.toLowerCase().contains(query.toLowerCase()) || s.artistName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showResults = _controller.text.isNotEmpty;

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
                                decoration: InputDecoration(border: InputBorder.none, hintText: 'Songs, artists...', hintStyle: TextStyle(color: Colors.grey.shade500)),
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
                child: showResults
                    ? (_results.isEmpty
                        ? Center(child: Text('No results found', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _results.length,
                            itemBuilder: (context, i) => SongTile(song: _results[i], onTap: () => MusicPlayerState.instance.playSong(_results[i], fromQueue: _results)),
                          ))
                    : widget.genres.isEmpty
                        ? Center(child: Text('Browse genres will appear here', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6),
                            itemCount: widget.genres.length,
                            itemBuilder: (context, i) => Container(
                              decoration: BoxDecoration(
                                color: kFieldColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(14),
                              alignment: Alignment.bottomLeft,
                              child: Text(widget.genres[i], style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
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