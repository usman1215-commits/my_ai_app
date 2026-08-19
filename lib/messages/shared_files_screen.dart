import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'message_models.dart';

/// Shared files list (documents/PDFs/etc shared in a chat).
/// FRONTEND ONLY — [files] placeholder list.
class SharedFilesScreen extends StatelessWidget {
  final List<SharedFileItem> files;

  const SharedFilesScreen({super.key, this.files = const []});

  IconData _iconFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_outlined;
      case 'doc': case 'docx': return Icons.description_outlined;
      case 'xls': case 'xlsx': return Icons.table_chart_outlined;
      case 'zip': case 'rar': return Icons.folder_zip_outlined;
      default: return Icons.insert_drive_file_outlined;
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
                    Text('Shared Files', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: files.isEmpty
                    ? Center(child: Text('No files shared yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: files.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final f = files[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Icon(_iconFor(f.fileExtension), color: kRedColor, size: 26),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(f.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 3),
                                      Text('${f.formattedSize} · ${f.sharedByName}', style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.download_outlined, color: Colors.grey.shade500, size: 20),
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