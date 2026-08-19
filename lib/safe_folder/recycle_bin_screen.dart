import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Recycle Bin — recently deleted items, restorable within a time
/// window before permanent deletion. FRONTEND ONLY — [items]
/// placeholder list.
class RecycleBinScreen extends StatefulWidget {
  final List<RecycleBinItem> items;

  const RecycleBinScreen({super.key, this.items = const []});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  late List<RecycleBinItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  void _restore(String id) {
    // TODO: call your real "restore item" backend/storage API here.
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _deleteForever(String id) {
    // TODO: call your real "permanently delete" backend/storage API here.
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  IconData _iconFor(RecycleItemType type) {
    switch (type) {
      case RecycleItemType.photo: return Icons.photo_outlined;
      case RecycleItemType.video: return Icons.videocam_outlined;
      case RecycleItemType.document: return Icons.description_outlined;
      case RecycleItemType.note: return Icons.sticky_note_2_outlined;
    }
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
                    Text('Recycle Bin', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: _items.isEmpty
                    ? Center(child: Text('Recycle bin is empty', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final item = _items[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Icon(_iconFor(item.type), color: Colors.grey.shade400, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
                                      Text('Deletes permanently in ${item.daysUntilPermanentDelete}d', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: () => _restore(item.id), icon: const Icon(Icons.restore, color: Colors.greenAccent, size: 20)),
                                IconButton(onPressed: () => _deleteForever(item.id), icon: const Icon(Icons.delete_forever, color: kRedColor, size: 20)),
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