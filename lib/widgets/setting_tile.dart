import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable settings row — icon, label, and a trailing
/// element that can be a chevron (navigation), a switch (toggle), or
/// a value label. Used across every settings-style screen in the app.
///
/// Usage:
///   SettingTile.navigation(icon: Icons.person, label: 'Account', onTap: () {})
///   SettingTile.toggle(icon: Icons.dark_mode, label: 'Dark Mode', value: true, onChanged: (v) {})
///   SettingTile.value(icon: Icons.language, label: 'Language', value: 'English')
class SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final String? valueText;

  const SettingTile.navigation({
    super.key,
    required this.icon,
    required this.label,
    this.isDestructive = false,
    this.onTap,
  })  : switchValue = null,
        onSwitchChanged = null,
        valueText = null;

  const SettingTile.toggle({
    super.key,
    required this.icon,
    required this.label,
    required bool value,
    required ValueChanged<bool> onChanged,
  })  : isDestructive = false,
        onTap = null,
        switchValue = value,
        onSwitchChanged = onChanged,
        valueText = null;

  const SettingTile.value({
    super.key,
    required this.icon,
    required this.label,
    required String value,
    this.onTap,
  })  : isDestructive = false,
        switchValue = null,
        onSwitchChanged = null,
        valueText = value;

  @override
  Widget build(BuildContext context) {
    if (switchValue != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
        child: SwitchListTile(
          value: switchValue!,
          onChanged: onSwitchChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: kRedColor,
          inactiveTrackColor: const Color(0xFF3A3A3A),
          secondary: Icon(icon, color: Colors.white70, size: 20),
          title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isDestructive ? kRedColor : Colors.white70, size: 20),
        title: Text(label, style: TextStyle(color: isDestructive ? kRedColor : Colors.white, fontSize: 13.5)),
        trailing: valueText != null
            ? Text(valueText!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5))
            : Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}