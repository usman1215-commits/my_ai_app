// Placeholder for password manager screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Password Manager — list of saved credentials, masked by default.
/// FRONTEND ONLY — [passwords] should arrive already-decrypted from a
/// secure backend call at the point of display; never store plain
/// passwords in local state longer than needed.
class PasswordManagerScreen extends StatefulWidget {
  final List<PasswordEntry> passwords;

  const PasswordManagerScreen({super.key, this.passwords = const []});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final Set<String> _revealedIds = {};

  void _toggleReveal(String id) {
    setState(() {
      if (_revealedIds.contains(id)) {
        _revealedIds.remove(id);
      } else {
        _revealedIds.add(id);
      }
    });
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
                    const Text('Password Manager', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: open "add new password" form, save via secure backend.
                    }, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: widget.passwords.isEmpty
                    ? Center(child: Text('No saved passwords yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: widget.passwords.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final p = widget.passwords[i];
                          final revealed = _revealedIds.contains(p.id);
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: kRedColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.language, color: kRedColor, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.siteName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 2),
                                      Text(p.username, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text(revealed ? p.password : '••••••••', style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, letterSpacing: revealed ? 0 : 2)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _toggleReveal(p.id),
                                  icon: Icon(revealed ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400, size: 20),
                                ),
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