import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'developer_screen.dart';
import 'licenses_screen.dart';
import 'terms_screen.dart';
import 'privacy_policy_screen.dart';

/// About — app logo/version + links to Developer, Licenses, Terms,
/// Privacy Policy. FRONTEND ONLY — [appVersion]/[buildNumber]
/// placeholders; pull real values via package_info_plus later.
class AboutScreen extends StatelessWidget {
  final String? appVersion;
  final String? buildNumber;

  const AboutScreen({super.key, this.appVersion, this.buildNumber});

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
                    Text('About', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 76, height: 76,
                decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.groups_rounded, color: kRedColor, size: 36),
              ),
              const SizedBox(height: 14),
              const Text('Ozzi', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'serif')),
              const SizedBox(height: 4),
              Text(
                'Version ${appVersion ?? '--'}${buildNumber != null ? ' ($buildNumber)' : ''}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _row(context, Icons.code, 'Developer', const DeveloperScreen()),
                    _row(context, Icons.article_outlined, 'Licenses', const LicensesScreen()),
                    _row(context, Icons.description_outlined, 'Terms of Service', const TermsScreen()),
                    _row(context, Icons.privacy_tip_outlined, 'Privacy Policy', const PrivacyPolicyScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, Widget screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)),
        leading: Icon(icon, color: kRedColor, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }
}