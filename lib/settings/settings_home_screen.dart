import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import '../ozzi_chat/ai_settings_screen.dart';
import '../navigation/app_routes.dart';
import 'account_screen.dart';
import 'appearance_screen.dart';
import 'notifications_screen.dart';
import 'privacy_screen.dart';
import 'about_screen.dart';
import 'developer_screen.dart';

/// Settings Home — grouped menu into every settings sub-screen.
/// FRONTEND ONLY.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _SectionLabel('General'),
                    _SettingsRow(icon: Icons.person_outline, label: 'Account', onTap: () => _push(context, const AccountScreen())),
                    _SettingsRow(icon: Icons.palette_outlined, label: 'Appearance', onTap: () => _push(context, const AppearanceScreen())),
                    _SettingsRow(icon: Icons.notifications_none, label: 'Notifications', onTap: () => _push(context, const NotificationsScreen())),
                    _SettingsRow(icon: Icons.lock_outline, label: 'Privacy', onTap: () => _push(context, const PrivacyScreen())),

                    _SectionLabel('AI'),
                    _SettingsRow(icon: Icons.smart_toy_outlined, label: 'AI Settings', onTap: () => _push(context, const AiSettingsScreen())),

                    _SectionLabel('Modules'),
                    _SettingsRow(icon: Icons.chat_bubble_outline, label: 'Messages', onTap: () => Navigator.of(context).pushNamed(AppRoutes.messages)),
                    _SettingsRow(icon: Icons.music_note_outlined, label: 'Music', onTap: () => Navigator.of(context).pushNamed(AppRoutes.music)),
                    _SettingsRow(icon: Icons.notes_rounded, label: 'Notes', onTap: () => Navigator.of(context).pushNamed(AppRoutes.notes)),
                    _SettingsRow(icon: Icons.lock_outline, label: 'Safe Folder', onTap: () => Navigator.of(context).pushNamed(AppRoutes.safeFolder)),
                    _SettingsRow(icon: Icons.person_outline, label: 'Profile', onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile)),

                    _SectionLabel('About'),
                    _SettingsRow(icon: Icons.info_outline, label: 'About', onTap: () => _push(context, const AboutScreen())),
                    _SettingsRow(icon: Icons.code_rounded, label: 'Developer Options', onTap: () => _push(context, const DeveloperScreen())),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(text.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: kRedColor, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}