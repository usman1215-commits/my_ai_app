import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'anonymous_mode_screen.dart';
import 'mode_18plus_screen.dart';

/// Privacy — general privacy toggles + shortcuts into Anonymous Mode
/// and 18+ Mode. FRONTEND ONLY.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _readReceipts = true;
  bool _onlineStatus = true;
  bool _profileVisible = true;

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
                    Text('Privacy', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _toggleTile('Read Receipts', Icons.done_all, _readReceipts, (v) => setState(() => _readReceipts = v)),
                    _toggleTile('Show Online Status', Icons.circle, _onlineStatus, (v) => setState(() => _onlineStatus = v)),
                    _toggleTile('Public Profile', Icons.public, _profileVisible, (v) => setState(() => _profileVisible = v)),
                    const SizedBox(height: 12),
                    _navTile('Anonymous Mode', Icons.visibility_off_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnonymousModeScreen()))),
                    _navTile('18+ Mode', Icons.explicit_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Mode18PlusScreen()))),
                    _navTile('Blocked Users', Icons.block, () {
                      // TODO: navigate to blocked users list screen.
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleTile(String label, IconData icon, bool value, ValueChanged<bool> onChanged) {
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

  Widget _navTile(String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: kRedColor, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}