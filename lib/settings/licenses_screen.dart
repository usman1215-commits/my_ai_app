import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Licenses — open-source package attributions.
/// FRONTEND ONLY — [licenses] placeholder list. For a quick real
/// implementation, you can alternatively call
/// `showLicensePage(context: context)` which uses Flutter's built-in
/// LICENSE registry from your pubspec dependencies.
class LicensesScreen extends StatelessWidget {
  final List<({String name, String license})> licenses;

  const LicensesScreen({super.key, this.licenses = const []});

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
                    Text('Licenses', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: licenses.isEmpty
                    ? Center(
                        child: TextButton(
                          onPressed: () => showLicensePage(context: context, applicationName: 'Ozzi'),
                          child: const Text('View Flutter package licenses', style: TextStyle(color: kRedColor, fontSize: 13)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: licenses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final l = licenses[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(l.license, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
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