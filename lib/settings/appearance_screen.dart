import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'theme_color_screen.dart';

/// Appearance — dark/light mode toggle, font size, Theme Color shortcut.
/// FRONTEND ONLY — toggles are local UI state; wire up a real
/// app-wide theme provider.
class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _mode = 'Dark'; // 'Dark' | 'Light' | 'System'
  double _fontScale = 1.0;

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
                    Text('Appearance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    Text('Mode', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: ['Dark', 'Light', 'System'].map((m) {
                          final isSelected = _mode == m;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: wire up real app-wide theme switching.
                                setState(() => _mode = m);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(color: isSelected ? kRedColor : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: Text(m, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade400, fontSize: 12.5, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ThemeColorScreen())),
                        leading: const Icon(Icons.palette_outlined, color: kRedColor, size: 20),
                        title: const Text('Theme Color', style: TextStyle(color: Colors.white, fontSize: 13.5)),
                        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Font Size', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          const Text('A', style: TextStyle(color: Colors.white, fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: _fontScale,
                              min: 0.8,
                              max: 1.4,
                              activeColor: kRedColor,
                              inactiveColor: Colors.grey.shade700,
                              onChanged: (v) => setState(() => _fontScale = v),
                            ),
                          ),
                          const Text('A', style: TextStyle(color: Colors.white, fontSize: 20)),
                        ],
                      ),
                    ),
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