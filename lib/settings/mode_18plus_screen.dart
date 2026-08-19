import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// 18+ Mode — unlocks mature content, gated behind an age
/// confirmation. FRONTEND ONLY — real age verification (ID check,
/// backend flag) should replace the simple confirm dialog below.
class Mode18PlusScreen extends StatefulWidget {
  final bool initialValue;

  const Mode18PlusScreen({super.key, this.initialValue = false});

  @override
  State<Mode18PlusScreen> createState() => _Mode18PlusScreenState();
}

class _Mode18PlusScreenState extends State<Mode18PlusScreen> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.initialValue;
  }

  Future<void> _toggle(bool v) async {
    if (v) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: kFieldColor,
          title: const Text('Confirm your age', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: Text('You must be 18 or older to enable this mode. Are you 18+?', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('I am 18+', style: TextStyle(color: kRedColor))),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    // TODO: call your real backend age-verification/preference API here.
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
                    Text('18+ Mode', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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
                        secondary: const Icon(Icons.explicit_outlined, color: kRedColor, size: 20),
                        title: const Text('Enable 18+ Mode', style: TextStyle(color: Colors.white, fontSize: 13.5)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Enabling this unlocks mature content and features not suitable for minors. Real age verification must be enforced on your backend — this local toggle alone is not sufficient for compliance.',
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