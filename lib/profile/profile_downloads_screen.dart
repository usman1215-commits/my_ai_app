import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Downloads — files the user has downloaded from the app.
/// FRONTEND ONLY — [downloads] placeholder list.
class ProfileDownloadsScreen extends StatelessWidget {
  final List<ProfileDownloadItem> downloads;

  const ProfileDownloadsScreen({super.key, this.downloads = const []});

  IconData _iconFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_outlined;
      case 'jpg': case 'jpeg': case 'png': return Icons.image_outlined;
      case 'mp4': case 'mov': return Icons.videocam_outlined;
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
                    Text('Downloads', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: downloads.isEmpty
                    ? Center(child: Text('No downloads yet', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: downloads.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final d = downloads[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
                            child: Row(
                              children: [
                                Icon(_iconFor(d.fileExtension), color: kRedColor, size: 24),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w500)),
                                      Text(d.formattedSize, style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.delete_outline, color: Colors.grey.shade500, size: 20),
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