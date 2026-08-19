
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Generic reusable empty state — icon, title, optional subtitle,
/// optional action button. Use anywhere a list/screen has no data
/// yet (no messages, no notes, no results, etc), instead of a bare
/// "Text" placeholder.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: kFieldColor, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.grey.shade600, size: 28),
            ),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5, height: 1.4)),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onActionTap,
                child: Text(actionLabel!, style: const TextStyle(color: kRedColor, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pre-configured empty state for "no results" search screens.
class EmptySearchResults extends StatelessWidget {
  final String query;

  const EmptySearchResults({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No results for "$query"',
      subtitle: 'Try a different search term.',
    );
  }
}

/// Pre-configured empty state for network/connection errors, with a
/// retry action.
class EmptyErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const EmptyErrorState({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'Something went wrong',
      subtitle: message ?? 'Check your connection and try again.',
      actionLabel: 'Retry',
      onActionTap: onRetry,
    );
  }
}