import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'profile_models.dart';

/// Edit Profile — update avatar/name/username/bio.
/// FRONTEND ONLY — wire up real image picker + save API where marked.
class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _usernameController = TextEditingController(text: widget.profile.username);
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Name cannot be empty');
      return;
    }
    setState(() {
      _errorMessage = null;
      _isSaving = true;
    });

    // TODO: replace with your real "update profile" API call.
    // If backend rejects it (e.g. username taken):
    //   setState(() { _isSaving = false; _errorMessage = result.errorMessage; });
    //   return;
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const OzziBackButton(),
                      const SizedBox(width: 12),
                      const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      TextButton(
                        onPressed: _isSaving ? null : _save,
                        child: Text(_isSaving ? 'Saving...' : 'Save', style: const TextStyle(color: kRedColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: kFieldColor,
                        backgroundImage: widget.profile.avatarUrl != null ? NetworkImage(widget.profile.avatarUrl!) : null,
                        child: widget.profile.avatarUrl == null ? const Icon(Icons.person, color: Colors.white54, size: 44) : null,
                      ),
                      Positioned(
                        right: 0, bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: open real image picker, upload new avatar.
                          },
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: kRedColor, shape: BoxShape.circle, border: Border.all(color: kBackgroundColor, width: 2)),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),

                OzziTextField(icon: Icons.person_outline, hint: 'Name', controller: _nameController),
                const SizedBox(height: 16),
                OzziTextField(icon: Icons.alternate_email, hint: 'Username', controller: _usernameController),
                const SizedBox(height: 16),
                OzziTextField(icon: Icons.info_outline, hint: 'Bio', controller: _bioController),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}