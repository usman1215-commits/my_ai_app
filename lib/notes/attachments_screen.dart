// Placeholder for attachments screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';

/// Attachments list for a note — add/view/download files.
/// FRONTEND ONLY — [attachments] placeholder list; wire up a real
/// file picker + upload where marked.
class AttachmentsScreen extends StatelessWidget {
  final List<NoteAttachment> attachments;

  const AttachmentsScreen({super.key, this.attachments = const []});

  IconData _iconFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_outlined;
      case 'jpg': case 'jpeg': case 'png': return Icons.image_outlined;
      case 'doc': case 'docx': return Icons.description_outlined;
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
                  children: [
                    const OzziBackButton(),
                    const SizedBox(width: 12),
                    const Text('Attachments', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // TODO: open a real file/image picker and upload.
                      },
                      icon: const Icon(Icons.add, color: kRedColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: attachments.isEmpty
                    ? Center(child: Text('No attachments yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: attachments.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final a = attachments[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Icon(_iconFor(a.fileExtension), color: kRedColor, size: 24),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(a.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
                                      Text(a.formattedSize, style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
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