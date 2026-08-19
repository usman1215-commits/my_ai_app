import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Developer credit screen. FRONTEND ONLY — [name]/[role]/[contactUrl]
/// are placeholders; fill in with your real info (or pull from a
/// backend config if you want it editable without a rebuild).
class DeveloperScreen extends StatelessWidget {
  final String? name;
  final String? role;
  final String? avatarUrl;
  final String? contactUrl;

  const DeveloperScreen({super.key, this.name, this.role, this.avatarUrl, this.contactUrl});

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
                    Text('Developer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 44,
                backgroundColor: kFieldColor,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Icons.person, color: Colors.white54, size: 40) : null,
              ),
              const SizedBox(height: 14),
              Text(name ?? '--', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(role ?? 'Developer', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              const SizedBox(height: 20),
              if (contactUrl != null)
                OutlinedButton(
                  onPressed: () {
                    // TODO: launch contactUrl via url_launcher.
                  },
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: kRedColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                  child: const Text('Contact', style: TextStyle(color: kRedColor)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}