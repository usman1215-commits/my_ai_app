import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Privacy Policy — scrollable legal text.
/// FRONTEND ONLY — [content] should be pulled from your backend/CMS
/// so legal text can be updated without an app release.
class PrivacyPolicyScreen extends StatelessWidget {
  final String? content;
  final DateTime? lastUpdated;

  const PrivacyPolicyScreen({super.key, this.content, this.lastUpdated});

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
                    Text('Privacy Policy', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lastUpdated != null)
                        Text('Last updated: ${lastUpdated!.day}/${lastUpdated!.month}/${lastUpdated!.year}', style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5)),
                      const SizedBox(height: 14),
                      Text(
                        content ?? 'Privacy policy content will appear here once loaded from the backend.',
                        style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.6),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}