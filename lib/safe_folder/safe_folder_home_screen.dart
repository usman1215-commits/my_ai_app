// Placeholder for safe folder home screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_widgets.dart';
import 'safe_photos_screen.dart';
import 'safe_videos_screen.dart';
import 'safe_documents_screen.dart';
import 'password_manager_screen.dart';
import 'hidden_notes_screen.dart';
import 'hidden_apps_screen.dart';
import 'recycle_bin_screen.dart';

/// Safe Folder Home — shown after PIN unlock. Category list into each
/// sub-section. FRONTEND ONLY — [counts] placeholder values from your
/// backend/local encrypted storage.
class SafeFolderHomeScreen extends StatelessWidget {
  final int? photoCount;
  final int? videoCount;
  final int? documentCount;
  final int? passwordCount;
  final int? noteCount;
  final int? recycleBinCount;

  const SafeFolderHomeScreen({
    super.key,
    this.photoCount,
    this.videoCount,
    this.documentCount,
    this.passwordCount,
    this.noteCount,
    this.recycleBinCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: kFieldColor, shape: BoxShape.circle),
                      child: const Icon(Icons.lock, color: kRedColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text('Safe Folder', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // TODO: open safe folder settings (change PIN, biometrics toggle, auto-lock timer).
                      },
                      icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    SafeCategoryTile(
                      icon: Icons.photo_outlined,
                      label: 'Photos',
                      count: photoCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SafePhotosScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.videocam_outlined,
                      label: 'Videos',
                      count: videoCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SafeVideosScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.description_outlined,
                      label: 'Documents',
                      count: documentCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SafeDocumentsScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.key_outlined,
                      label: 'Password Manager',
                      count: passwordCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PasswordManagerScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.sticky_note_2_outlined,
                      label: 'Hidden Notes',
                      count: noteCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HiddenNotesScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.apps_outlined,
                      label: 'Hidden Apps',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HiddenAppsScreen())),
                    ),
                    const SizedBox(height: 10),
                    SafeCategoryTile(
                      icon: Icons.delete_outline,
                      label: 'Recycle Bin',
                      count: recycleBinCount,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecycleBinScreen())),
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