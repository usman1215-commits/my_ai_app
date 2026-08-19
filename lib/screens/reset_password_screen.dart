import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import 'password_changed_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text.isEmpty || _confirmController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in both fields');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // TODO: replace with your real "set new password" API call.
    // If backend rejects it (e.g. weak password):
    //   setState(() { _isLoading = false; _errorMessage = result.errorMessage; });
    //   return;
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PasswordChangedScreen()),
      (route) => route.isFirst, // clears the reset flow off the back stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const OzziBackButton(),
                const SizedBox(height: 60),
                const OzziHeader(subtitle: 'Create a new password'),
                const SizedBox(height: 16),
                Text(
                  'Your new password must be different\nfrom your previous password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 36),

                if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),

                OzziTextField(
                  icon: Icons.lock,
                  hint: 'Enter New Password',
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 16),
                OzziTextField(
                  icon: Icons.lock,
                  hint: 'Confirm New Password',
                  obscureText: true,
                  controller: _confirmController,
                ),

                const SizedBox(height: 28),
                OzziPrimaryButton(
                  label: _isLoading ? 'Saving...' : 'Reset Password',
                  onPressed: _isLoading ? () {} : _resetPassword,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}