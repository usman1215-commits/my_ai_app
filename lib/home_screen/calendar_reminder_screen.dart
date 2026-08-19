import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// A single calendar event/reminder.
/// FRONTEND ONLY — shape only, populate from your backend/local DB.
class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay? time;

  CalendarEvent({required this.id, required this.title, required this.date, this.time});
}

/// Calendar Reminder — opened from the "+" on Home's date card.
/// Full month calendar + add/view/delete events for the selected day.
/// FRONTEND ONLY — [events] placeholder list; wire up real
/// create/delete backend calls where marked.
class CalendarReminderScreen extends StatefulWidget {
  final List<CalendarEvent> events;

  const CalendarReminderScreen({super.key, this.events = const []});

  @override
  State<CalendarReminderScreen> createState() => _CalendarReminderScreenState();
}

class _CalendarReminderScreenState extends State<CalendarReminderScreen> {
  late DateTime _selectedDate;
  late List<CalendarEvent> _events;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _events = List.of(widget.events);
  }

  List<CalendarEvent> get _eventsForSelectedDay => _events
      .where((e) => e.date.year == _selectedDate.year && e.date.month == _selectedDate.month && e.date.day == _selectedDate.day)
      .toList()
    ..sort((a, b) => (a.time?.hour ?? 0).compareTo(b.time?.hour ?? 0));

  Future<void> _addEvent() async {
    final titleController = TextEditingController();
    TimeOfDay? pickedTime;

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                const Text('Add Reminder', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                OzziTextField(icon: Icons.event_note, hint: 'Event title', controller: titleController),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(context: sheetContext, initialTime: TimeOfDay.now());
                    if (t != null) setSheetState(() => pickedTime = t);
                  },
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(27)),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: kRedColor, size: 20),
                        const SizedBox(width: 12),
                        Text(pickedTime != null ? pickedTime!.format(sheetContext) : 'Set time (optional)', style: TextStyle(color: pickedTime != null ? Colors.white : Colors.grey.shade500, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OzziPrimaryButton(
                  label: 'Save Reminder',
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.of(sheetContext).pop(titleController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      // TODO: save this event to your real backend/local database here.
      setState(() {
        _events.add(CalendarEvent(id: DateTime.now().toString(), title: result, date: _selectedDate, time: pickedTime));
      });
    }
  }

  void _deleteEvent(String id) {
    // TODO: call your real "delete event" backend API here.
    setState(() => _events.removeWhere((e) => e.id == id));
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
                    const Text('Calendar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: kRedColor,
                    onPrimary: Colors.white,
                    surface: kBackgroundColor,
                    onSurface: Colors.white,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  onDateChanged: (d) => setState(() => _selectedDate = d),
                ),
              ),
              const Divider(color: Color(0xFF2E2E2E), height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Row(
                  children: [
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _addEvent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: kRedColor, borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Add', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _eventsForSelectedDay.isEmpty
                    ? Center(child: Text('No reminders on this day', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _eventsForSelectedDay.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final e = _eventsForSelectedDay[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                const Icon(Icons.event_note, color: kRedColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(e.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                      if (e.time != null)
                                        Text(e.time!.format(context), style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: () => _deleteEvent(e.id), icon: const Icon(Icons.delete_outline, color: kRedColor, size: 20)),
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