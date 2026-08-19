import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // TODO: replace with your real "send reset code" API call.
    // If the backend says the email doesn't exist, etc:
    //   setState(() { _isLoading = false; _errorMessage = result.errorMessage; });
    //   return;
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(email: _emailController.text.trim()),
      ),
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
                const OzziHeader(subtitle: 'Reset your password'),
                const SizedBox(height: 16),
                Text(
                  "Enter the email linked to your account and we'll\nsend you a code to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 36),

                if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),

                OzziTextField(
                  icon: Icons.email,
                  hint: 'Enter Your Email',
                  controller: _emailController,
                ),

                const SizedBox(height: 28),
                OzziPrimaryButton(
                  label: _isLoading ? 'Sending...' : 'Send Code',
                  onPressed: _isLoading ? () {} : _sendCode,
                ),

                const SizedBox(height: 40),
                SwitchAuthRow(
                  leading: 'Remember your password?',
                  action: 'Login',
                  onTap: () => Navigator.of(context).pop(),
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