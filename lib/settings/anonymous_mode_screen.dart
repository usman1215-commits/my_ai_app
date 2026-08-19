import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Anonymous Mode — hides identity/activity from other users when on.
/// FRONTEND ONLY — wire the toggle up to a real backend preference call.
class AnonymousModeScreen extends StatefulWidget {
  final bool initialValue;

  const AnonymousModeScreen({super.key, this.initialValue = false});

  @override
  State<AnonymousModeScreen> createState() => _AnonymousModeScreenState();
}

class _AnonymousModeScreenState extends State<AnonymousModeScreen> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.initialValue;
  }

  void _toggle(bool v) {
    // TODO: call your real backend to persist this preference.
    setState(() => _enabled = v);
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
                    Text('Anonymous Mode', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                      child: SwitchListTile(
                        value: _enabled,
                        onChanged: _toggle,
                        activeThumbColor: Colors.white,
                        activeTrackColor: kRedColor,
                        inactiveTrackColor: const Color(0xFF3A3A3A),
                        secondary: const Icon(Icons.visibility_off_outlined, color: kRedColor, size: 20),
                        title: const Text('Enable Anonymous Mode', style: TextStyle(color: Colors.white, fontSize: 13.5)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'When enabled, your name and profile picture are hidden from other users in chats and activity. Some features may be limited while Anonymous Mode is on.',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5, height: 1.5),
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