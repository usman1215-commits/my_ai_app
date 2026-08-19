import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// Bottom bar with a single "Chat AI" action that opens OzziScreen
/// (chat history / AI settings / voice chat hub).
class OzziBottomNavBar extends StatelessWidget {
  final VoidCallback onChatAiTap;

  const OzziBottomNavBar({
    super.key,
    required this.onChatAiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onChatAiTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: kRedColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Chat AI',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}