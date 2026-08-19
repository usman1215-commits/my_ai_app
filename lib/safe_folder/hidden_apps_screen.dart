// Placeholder for hidden apps screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden Apps — UI ONLY toggle list. Actually hiding installed apps
/// from a device home screen/launcher requires native platform code
/// (very different per OS and often requires system-level permissions
/// or a custom launcher) — this screen only provides the toggle UI;
/// wire up the real platform channel / native implementation later.
class HiddenAppsScreen extends StatefulWidget {
  final List<HiddenAppEntry> apps;

  const HiddenAppsScreen({super.key, this.apps = const []});

  @override
  State<HiddenAppsScreen> createState() => _HiddenAppsScreenState();
}

class _HiddenAppsScreenState extends State<HiddenAppsScreen> {
  late List<HiddenAppEntry> _apps;

  @override
  void initState() {
    super.initState();
    _apps = List.of(widget.apps);
  }

  void _toggle(String id, bool value) {
    // TODO: wire up real native platform-channel logic to actually
    // hide/show the app from the device launcher.
    setState(() {
      _apps = _apps.map((a) => a.id == id ? HiddenAppEntry(id: a.id, appName: a.appName, iconUrl: a.iconUrl, isHidden: value) : a).toList();
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
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('Hidden Apps', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade400, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text('UI preview only — native OS integration required to actually hide apps.', style: TextStyle(color: Colors.grey.shade400, fontSize: 11))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _apps.isEmpty
                    ? Center(child: Text('No apps found on this device', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: _apps.length,
                        itemBuilder: (context, i) {
                          final app = _apps[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: SwitchListTile(
                              value: app.isHidden,
                              onChanged: (v) => _toggle(app.id, v),
                              activeThumbColor: Colors.white,
                              activeTrackColor: kRedColor,
                              inactiveTrackColor: const Color(0xFF3A3A3A),
                              secondary: CircleAvatar(
                                backgroundColor: kBackgroundColor,
                                backgroundImage: app.iconUrl != null ? NetworkImage(app.iconUrl!) : null,
                                child: app.iconUrl == null ? const Icon(Icons.apps, color: Colors.white54, size: 18) : null,
                              ),
                              title: Text(app.appName, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
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