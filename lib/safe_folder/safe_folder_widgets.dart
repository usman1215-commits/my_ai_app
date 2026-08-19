// Placeholder for safe folder widgets.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

String formatSafeDate(DateTime d) {
  return '${d.day}/${d.month}/${d.year}';
}

/// Category tile used on Safe Folder Home (Photos, Videos, etc).
class SafeCategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final VoidCallback onTap;

  const SafeCategoryTile({
    super.key,
    required this.icon,
    required this.label,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kFieldColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: kRedColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: kRedColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600)),
              ),
              if (count != null)
                Text('$count', style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5)),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}