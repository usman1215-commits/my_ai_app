// Placeholder for checklist screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';

/// Checklist note editor — add/check/remove items.
/// FRONTEND ONLY — [note] passed in for editing (null = new checklist).
class ChecklistScreen extends StatefulWidget {
  final Note? note;

  const ChecklistScreen({super.key, this.note});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late final TextEditingController _titleController;
  final _newItemController = TextEditingController();
  late List<ChecklistItem> _items;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _items = List.of(widget.note?.checklistItems ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _newItemController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _newItemController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(ChecklistItem(id: DateTime.now().toString(), text: text));
      _newItemController.clear();
    });
  }

  void _toggleItem(String id) {
    setState(() {
      _items = _items.map((i) => i.id == id ? i.copyWith(isDone: !i.isDone) : i).toList();
    });
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _save() {
    // TODO: save this checklist note (title + items) to your real
    // backend/local database here.
    Navigator.of(context).pop();
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
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const Spacer(),
                    TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Checklist title', hintStyle: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              const Divider(color: Color(0xFF2E2E2E)),
              Expanded(
                child: _items.isEmpty
                    ? Center(child: Text('No items yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                          final item = _items[i];
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () => _toggleItem(item.id),
                              child: Icon(item.isDone ? Icons.check_box : Icons.check_box_outline_blank, color: item.isDone ? kRedColor : Colors.grey.shade500),
                            ),
                            title: Text(
                              item.text,
                              style: TextStyle(color: item.isDone ? Colors.grey.shade500 : Colors.white, fontSize: 14, decoration: item.isDone ? TextDecoration.lineThrough : null),
                            ),
                            trailing: IconButton(onPressed: () => _removeItem(item.id), icon: const Icon(Icons.close, color: Colors.grey, size: 18)),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newItemController,
                        onSubmitted: (_) => _addItem(),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kFieldColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          hintText: 'Add item...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addItem,
                      child: Container(width: 46, height: 46, decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white)),
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