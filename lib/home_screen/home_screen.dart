import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import '../widgets/ai_card.dart';
import '../ozzi_chat/ozzi_screen.dart';
import '../navigation/app_routes.dart';
import 'gender_select_screen.dart';
import 'calendar_reminder_screen.dart';

/// The 3 weather categories shown in the design (rain / sun / cloud icon column).
enum WeatherCondition { rain, sun, cloud }

/// A single saved message/note row shown in the list, with a delete action.
class NoteItem {
  final String id;
  final String text;

  NoteItem({required this.id, required this.text});
}

/// Home screen — matches the Figma design exactly:
/// welcome header, weather card, date card, a "NEW" divider with a
/// Gender tag, a list of saved message notes (each deletable), a
/// RESET button, and the bottom nav bar.
///
/// FRONTEND ONLY. Every piece of dynamic content below is passed in
/// as a parameter/placeholder — nothing is hardcoded. Wire each one
/// up to your backend/Firebase/device APIs later:
///   - profileImageUrl      -> user's uploaded DP
///   - userName              -> logged-in user's name (if you want it in "welcome")
///   - weatherTemperature    -> live weather API
///   - weatherCondition      -> live weather API (drives which icon is highlighted)
///   - weatherDescription    -> live weather API (e.g. "Partly Cloudy")
///   - locationText           -> device location / geocoding API
///   - notes                 -> saved messages/notes from backend/DB
class HomeScreen extends StatefulWidget {
  final String? profileImageUrl;
  final String? weatherTemperature;      // e.g. "13°C" — null shows a placeholder dash
  final WeatherCondition? weatherCondition;
  final String? weatherDescription;      // e.g. "Partly Cloudy"
  final String? locationText;            // e.g. "Lahore, Pakistan"
  final List<NoteItem> notes;

  const HomeScreen({
    super.key,
    this.profileImageUrl,
    this.weatherTemperature,
    this.weatherCondition,
    this.weatherDescription,
    this.locationText,
    this.notes = const [],
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<NoteItem> _notes;

  @override
  void initState() {
    super.initState();
    _notes = List.of(widget.notes);
  }

  void _deleteNote(String id) {
    // TODO: also delete from backend/DB here.
    setState(() => _notes.removeWhere((n) => n.id == id));
  }

  void _resetAll() {
    // TODO: call your real reset/clear API here.
    setState(() => _notes.clear());
  }

  void _onAddDate() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CalendarReminderScreen()),
    );
  }

  void _onGenderTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GenderSelectScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const monthNames = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Welcome header ──────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: kFieldColor,
                            backgroundImage: widget.profileImageUrl != null
                                ? NetworkImage(widget.profileImageUrl!)
                                : null,
                            child: widget.profileImageUrl == null
                                ? const Icon(Icons.person, color: Colors.white, size: 20)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'welcome',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontFamily: 'serif',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'to ozzi your personal AI Assistant',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settingsHome),
                            icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 22),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Weather card + Date card row ────────────
                      // Wrapped in IntrinsicHeight because this Row uses
                      // CrossAxisAlignment.stretch while sitting inside a
                      // Column/SingleChildScrollView (unbounded height) —
                      // without it, stretch tries to fill infinite height
                      // and crashes with "BoxConstraints forces an
                      // infinite height".
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _WeatherCard(
                              temperature: widget.weatherTemperature,
                              condition: widget.weatherCondition,
                              description: widget.weatherDescription,
                              location: widget.locationText,
                            )),
                            const SizedBox(width: 12),
                            _DateCard(
                              day: now.day.toString(),
                              month: monthNames[now.month - 1],
                              onAddTap: _onAddDate,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── "NEW" divider + Gender tag ──────────────
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade700, thickness: 0.6)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12, letterSpacing: 1),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade700, thickness: 0.6)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _onGenderTap,
                            child: Column(
                              children: [
                                const Icon(Icons.person, color: kRedColor, size: 18),
                                Text('Gender', style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Notes list ───────────────────────────────
                      if (_notes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'No messages yet',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ),
                        )
                      else
                        ..._notes.map((note) => _NoteTile(
                              note: note,
                              onDelete: () => _deleteNote(note.id),
                            )),

                      const SizedBox(height: 24),

                      // ── Reset button ─────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _resetAll,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRedColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                          ),
                          child: const Text('RESET', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AiCard(
                        icon: Icons.auto_awesome,
                        title: 'Chat with Ozzi',
                        description: 'Your personal AI assistant is ready to help.',
                        actionLabel: 'Open Chat',
                        onActionTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OzziScreen())),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OzziScreen())),
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

class _WeatherCard extends StatelessWidget {
  final String? temperature;
  final WeatherCondition? condition;
  final String? description;
  final String? location;

  const _WeatherCard({this.temperature, this.condition, this.description, this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                temperature ?? '--°C',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Column(
                children: [
                  _icon(Icons.water_drop_rounded, condition == WeatherCondition.rain),
                  const SizedBox(height: 4),
                  _icon(Icons.wb_sunny_rounded, condition == WeatherCondition.sun),
                  const SizedBox(height: 4),
                  _icon(Icons.cloud_rounded, condition == WeatherCondition.cloud),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description ?? '—',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            location ?? '—',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, bool isActive) {
    return Icon(icon, size: 16, color: isActive ? Colors.greenAccent : Colors.grey.shade600);
  }
}

class _DateCard extends StatelessWidget {
  final String day;
  final String month;
  final VoidCallback onAddTap;

  const _DateCard({required this.day, required this.month, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
          Text(month, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onAddTap,
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final NoteItem note;
  final VoidCallback onDelete;

  const _NoteTile({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              note.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: kRedColor, size: 20),
          ),
        ],
      ),
    );
  }
}