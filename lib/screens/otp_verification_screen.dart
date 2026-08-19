import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  String _code = '';
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _verify() async {
    if (_code.length < 4) {
      setState(() => _errorMessage = 'Please enter the full 4-digit code');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // TODO: replace with your real "verify code" API call.
    // If backend says the code is wrong/expired:
    //   setState(() { _isLoading = false; _errorMessage = result.errorMessage; });
    //   return;
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  void _resendCode(BuildContext context) {
    // TODO: call your real "resend code" API here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resent')),
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
                const OzziHeader(subtitle: 'Enter verification code'),
                const SizedBox(height: 16),
                Text(
                  'We sent a 4-digit code to\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 40),

                if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),

                OzziOtpRow(
                  controllers: _controllers,
                  onCompleted: (code) => setState(() => _code = code),
                ),

                const SizedBox(height: 28),
                OzziPrimaryButton(
                  label: _isLoading ? 'Verifying...' : 'Verify Code',
                  onPressed: _isLoading ? () {} : _verify,
                ),

                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => _resendCode(context),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13),
                        children: [
                          TextSpan(text: "Didn't receive the code? ", style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'Resend', style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
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