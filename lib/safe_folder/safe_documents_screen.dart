// Placeholder for safe documents screen.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_models.dart';

/// Hidden documents list. FRONTEND ONLY — [documents] placeholder
/// list; tapping "+" opens the device file picker right away. Newly
/// picked files are shown locally — wire up your real "move to safe"
/// + secure upload API where marked.
class SafeDocumentsScreen extends StatefulWidget {
  final List<SafeMediaItem> documents;

  const SafeDocumentsScreen({super.key, this.documents = const []});

  @override
  State<SafeDocumentsScreen> createState() => _SafeDocumentsScreenState();
}

class _SafeDocumentsScreenState extends State<SafeDocumentsScreen> {
  final List<PlatformFile> _pickedDocs = [];

  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    // TODO: upload each picked file to your real secure backend/safe
    // storage here, then refresh [documents] from the backend instead
    // of just holding them in local state.
    setState(() => _pickedDocs.addAll(result.files));
  }

  IconData _iconFor(String? ext) {
    switch ((ext ?? '').toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_outlined;
      case 'doc': case 'docx': return Icons.description_outlined;
      case 'xls': case 'xlsx': return Icons.table_chart_outlined;
      default: return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.documents.length + _pickedDocs.length;

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
                    IconButton(onPressed: _pickDocuments, icon: const Icon(Icons.add, color: kRedColor)),
                  ],
                ),
              ),
              Expanded(
                child: totalCount == 0
                    ? Center(child: Text('No hidden documents yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: totalCount,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          if (i < widget.documents.length) {
                            final d = widget.documents[i];
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
                          }
                          final file = _pickedDocs[i - widget.documents.length];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Icon(_iconFor(file.extension), color: kRedColor, size: 24),
                                const SizedBox(width: 14),
                                Expanded(child: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5))),
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