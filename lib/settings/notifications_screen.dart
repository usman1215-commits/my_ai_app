import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Notifications — toggle list for push/email/sound/vibration and
/// per-category alerts. FRONTEND ONLY — local UI state; wire up real
/// device notification permissions + backend preference sync.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _push = true;
  bool _email = false;
  bool _sound = true;
  bool _vibration = true;
  bool _messages = true;
  bool _mentions = true;
  bool _reminders = true;

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
                    Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _tile('Push Notifications', Icons.notifications_none, _push, (v) => setState(() => _push = v)),
                    _tile('Email Notifications', Icons.email_outlined, _email, (v) => setState(() => _email = v)),
                    _tile('Sound', Icons.volume_up_outlined, _sound, (v) => setState(() => _sound = v)),
                    _tile('Vibration', Icons.vibration, _vibration, (v) => setState(() => _vibration = v)),
                    const SizedBox(height: 12),
                    Text('Categories', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _tile('Messages', Icons.chat_bubble_outline, _messages, (v) => setState(() => _messages = v)),
                    _tile('Mentions', Icons.alternate_email, _mentions, (v) => setState(() => _mentions = v)),
                    _tile('Reminders', Icons.alarm, _reminders, (v) => setState(() => _reminders = v)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(String label, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: kRedColor,
        inactiveTrackColor: const Color(0xFF3A3A3A),
        secondary: Icon(icon, color: Colors.white70, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
      ),
    );
  }
}