import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';
import 'message_widgets.dart';

/// Call log screen. FRONTEND ONLY — [callLogs] placeholder list,
/// wire up to your backend/call-history source later.
class CallsScreen extends StatelessWidget {
  final List<CallLogItem> callLogs;

  const CallsScreen({super.key, this.callLogs = const []});

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
                    Text('Calls', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: callLogs.isEmpty
                    ? Center(child: Text('No call history yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: callLogs.length,
                        separatorBuilder: (_, _) => Divider(color: Colors.grey.shade800, height: 24),
                        itemBuilder: (context, i) => _CallLogTile(call: callLogs[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallLogTile extends StatelessWidget {
  final CallLogItem call;
  const _CallLogTile({required this.call});

  IconData get _directionIcon {
    switch (call.direction) {
      case CallDirection.incoming: return Icons.call_received;
      case CallDirection.outgoing: return Icons.call_made;
      case CallDirection.missed: return Icons.call_missed;
    }
  }

  Color get _directionColor => call.direction == CallDirection.missed ? kRedColor : Colors.greenAccent;

  String _formatDuration(Duration? d) {
    if (d == null) return '';
    final m = d.inMinutes;
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChatAvatar(imageUrl: call.userAvatarUrl, radius: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(call.userName, style: TextStyle(color: call.direction == CallDirection.missed ? kRedColor : Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(_directionIcon, color: _directionColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${call.time.hour}:${call.time.minute.toString().padLeft(2, '0')}'
                    '${call.duration != null ? ' · ${_formatDuration(call.duration)}' : ''}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(call.type == CallType.video ? Icons.videocam_outlined : Icons.call_outlined, color: kRedColor, size: 20),
      ],
    );
  }
}