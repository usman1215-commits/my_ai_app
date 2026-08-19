// Placeholder for safe documents screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden documents list. FRONTEND ONLY — [documents] placeholder list.
class SafeDocumentsScreen extends StatelessWidget {
  final List<SafeMediaItem> documents;

  const SafeDocumentsScreen({super.key, this.documents = const []});

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
                    const Text('Documents', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(onPressed: () {
                      // TODO: open device file picker to add to safe folder.
                    }, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: documents.isEmpty
                    ? Center(child: Text('No hidden documents yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: documents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final d = documents[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                const Icon(Icons.description_outlined, color: kRedColor, size: 24),
                                const SizedBox(width: 14),
                                Expanded(child: Text(d.fileName ?? 'Untitled document', style: const TextStyle(color: Colors.white, fontSize: 13.5))),
                                Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 18),
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