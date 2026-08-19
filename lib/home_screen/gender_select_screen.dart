import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Gender Select — opened from the "Gender" tag on Home.
/// FRONTEND ONLY — [initialSelection] placeholder; wire up a real
/// "save gender preference" backend call in [_save].
class GenderSelectScreen extends StatefulWidget {
  final String? initialSelection;

  const GenderSelectScreen({super.key, this.initialSelection});

  @override
  State<GenderSelectScreen> createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  String? _selected;
  bool _isSaving = false;

  static const _options = [
    ('Male', Icons.male),
    ('Female', Icons.female),
    ('Non-binary', Icons.transgender),
    ('Prefer not to say', Icons.remove_circle_outline),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection;
  }

  Future<void> _save() async {
    if (_selected == null) return;
    setState(() => _isSaving = true);

    // TODO: call your real "save gender preference" backend API here.
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    Navigator.of(context).pop(_selected);
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
                    const Text('Select Gender', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: (_selected == null || _isSaving) ? null : _save,
                      child: Text(_isSaving ? 'Saving...' : 'Save', style: TextStyle(color: _selected == null ? Colors.grey : kRedColor, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _options.map((opt) {
                    final label = opt.$1;
                    final icon = opt.$2;
                    final isSelected = _selected == label;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? kRedColor.withValues(alpha: 0.15) : kFieldColor,
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected ? Border.all(color: kRedColor, width: 1.2) : null,
                      ),
                      child: ListTile(
                        onTap: () => setState(() => _selected = label),
                        leading: Icon(icon, color: isSelected ? kRedColor : Colors.white70, size: 22),
                        title: Text(label, style: TextStyle(color: isSelected ? kRedColor : Colors.white, fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                        trailing: isSelected ? const Icon(Icons.check_circle, color: kRedColor, size: 20) : null,
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