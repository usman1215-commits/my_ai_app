// Placeholder for voice notes screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';
import 'note_widgets.dart';

/// Voice Notes — list of recorded voice notes + record button.
/// FRONTEND ONLY — [voiceNotes] placeholder list; wire up real
/// microphone recording (e.g. record package) where marked.
class VoiceNotesScreen extends StatefulWidget {
  final List<Note> voiceNotes;

  const VoiceNotesScreen({super.key, this.voiceNotes = const []});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {
  bool _isRecording = false;

  void _toggleRecording() {
    // TODO: start/stop real audio recording, then save as a Note
    // (type: voice) to your backend/local database.
    setState(() => _isRecording = !_isRecording);
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
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('Voice Notes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: widget.voiceNotes.isEmpty
                    ? Center(child: Text('No voice notes yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: widget.voiceNotes.length,
                        itemBuilder: (context, i) {
                          final n = widget.voiceNotes[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Container(width: 40, height: 40, decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle), child: const Icon(Icons.play_arrow, color: Colors.white, size: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(n.title.isEmpty ? 'Untitled' : n.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                      Text(n.voiceDuration != null ? formatNoteDuration(n.voiceDuration!) : '--:--', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Text(formatNoteDate(n.updatedAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(color: _isRecording ? kRedColor : kFieldColor, shape: BoxShape.circle),
                      child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 32),
                    ),
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