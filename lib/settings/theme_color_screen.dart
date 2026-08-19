import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Theme Color — pick the app's accent color.
/// FRONTEND ONLY — selecting a color here is local UI state only;
/// wire it up to a real app-wide theme provider (e.g. Provider/Riverpod)
/// so the choice actually re-themes the app and persists.
class ThemeColorScreen extends StatefulWidget {
  final Color initialColor;

  const ThemeColorScreen({super.key, this.initialColor = kRedColor});

  @override
  State<ThemeColorScreen> createState() => _ThemeColorScreenState();
}

class _ThemeColorScreenState extends State<ThemeColorScreen> {
  late Color _selected;

  static const _palette = [
    kRedColor,
    Color(0xFFFF9800),
    Color(0xFFFFC107),
    Color(0xFF4CAF50),
    Color(0xFF00BCD4),
    Color(0xFF2196F3),
    Color(0xFF7B7BFF),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialColor;
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
                    Text('Theme Color', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: _palette.map((c) {
                    final isSelected = c.toARGB32() == _selected.toARGB32();
                    return GestureDetector(
                      onTap: () {
                        // TODO: persist choice to a real app-wide theme provider.
                        setState(() => _selected = c);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}