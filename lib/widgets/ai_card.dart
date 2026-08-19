
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// A card highlighting an AI suggestion/insight/shortcut — icon,
/// title, description, optional action button. FRONTEND ONLY.
class AiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;

  const AiCard({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onActionTap,
    this.onTap,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: kRedColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: kRedColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(description!, style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, height: 1.4)),
                    ],
                    if (actionLabel != null) ...[
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: onActionTap,
                        child: Text(actionLabel!, style: const TextStyle(color: kRedColor, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ),
                    ],
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