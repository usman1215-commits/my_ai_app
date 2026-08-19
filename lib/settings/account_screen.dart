import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Account — email/phone display, change password, delete account.
/// FRONTEND ONLY — [email]/[phone] placeholders; wire up real backend
/// calls where marked.
class AccountScreen extends StatelessWidget {
  final String? email;
  final String? phone;

  const AccountScreen({super.key, this.email, this.phone});

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
                    Text('Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email ?? '--'),
                    _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: phone ?? 'Not added'),
                    const SizedBox(height: 16),
                    _ActionRow(icon: Icons.lock_reset, label: 'Change Password', onTap: () {
                      // TODO: navigate to change-password flow / call backend.
                    }),
                    _ActionRow(icon: Icons.logout, label: 'Log Out', onTap: () {
                      // TODO: call your real logout API, clear session, navigate to Login.
                    }),
                    _ActionRow(icon: Icons.delete_forever_outlined, label: 'Delete Account', isDestructive: true, onTap: () {
                      // TODO: show confirm dialog, then call your real delete-account API.
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
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionRow({required this.icon, required this.label, this.isDestructive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isDestructive ? kRedColor : Colors.white70, size: 20),
        title: Text(label, style: TextStyle(color: isDestructive ? kRedColor : Colors.white, fontSize: 13.5)),
      ),
    );
  }
}