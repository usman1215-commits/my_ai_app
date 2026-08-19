// Placeholder for categories screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';

/// Manage note categories — list + add new.
/// FRONTEND ONLY — [categories] placeholder list; wire up real
/// create/delete API calls where marked.
class CategoriesScreen extends StatefulWidget {
  final List<NoteCategory> categories;

  const CategoriesScreen({super.key, this.categories = const []});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<NoteCategory> _categories;
  final _nameController = TextEditingController();

  static const _palette = [kRedColor, Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFFF9800), Color(0xFF9C27B0)];

  @override
  void initState() {
    super.initState();
    _categories = List.of(widget.categories);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    // TODO: call your real "create category" API here.
    setState(() {
      _categories.add(NoteCategory(
        id: DateTime.now().toString(),
        name: name,
        color: _palette[_categories.length % _palette.length],
        icon: Icons.label_outline,
      ));
      _nameController.clear();
    });
  }

  void _removeCategory(String id) {
    // TODO: call your real "delete category" API here.
    setState(() => _categories.removeWhere((c) => c.id == id));
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
                    Text('Categories', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: OzziTextField(icon: Icons.label_outline, hint: 'New category name', controller: _nameController)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addCategory,
                      child: Container(width: 48, height: 48, decoration: const BoxDecoration(color: kRedColor, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _categories.isEmpty
                    ? Center(child: Text('No categories yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _categories.length,
                        itemBuilder: (context, i) {
                          final c = _categories[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: ListTile(
                              leading: CircleAvatar(backgroundColor: c.color, radius: 10),
                              title: Text(c.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                              trailing: IconButton(onPressed: () => _removeCategory(c.id), icon: const Icon(Icons.close, color: Colors.grey, size: 18)),
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