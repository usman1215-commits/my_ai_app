import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/ozzi_widgets.dart';

class Reminder {
  final DateTime date;
  final String note;

  Reminder({required this.date, required this.note});
}

/// Opens a dark-themed calendar bottom sheet (via [showReminderSheet])
/// where the user picks a date and types a reminder note.
/// Returns the created [Reminder], or null if cancelled.
Future<Reminder?> showReminderSheet(BuildContext context) {
  return showModalBottomSheet<Reminder>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ReminderSheet(),
  );
}

class _ReminderSheet extends StatefulWidget {
  const _ReminderSheet();

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  DateTime _selectedDate = DateTime.now();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Reminder',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Dark-themed calendar for picking the reminder date.
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: kRedColor,       // selected date color
                  onPrimary: Colors.white,
                  surface: kBackgroundColor,
                  onSurface: Colors.white,
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
            ),

            const SizedBox(height: 8),
            OzziTextField(
              icon: Icons.edit_note,
              hint: 'What do you want to be reminded about?',
              controller: _noteController,
            ),
            const SizedBox(height: 20),

            OzziPrimaryButton(
              label: 'Save Reminder — ${DateFormat('d MMM, yyyy').format(_selectedDate)}',
              onPressed: () {
                if (_noteController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please add a note for the reminder')),
                  );
                  return;
                }
                Navigator.of(context).pop(
                  Reminder(date: _selectedDate, note: _noteController.text.trim()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}