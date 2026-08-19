import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import '../navigation/app_page_route.dart';
import '../navigation/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Backend-driven state — stays null until your real API call sets it
  // (e.g. "Email already registered").
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSocialTap(BuildContext context, String provider) {
    // TODO: replace with real Google/Facebook/Apple sign-in logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign up tapped')),
    );
  }

  Future<void> _handleCreateAccount() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // ─────────────────────────────────────────────────────────────
    // TODO: replace this whole block with your real register/signup
    // API call. Example shape:
    //
    //   final result = await AuthApi.register(
    //     name: _nameController.text.trim(),
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text,
    //   );
    //   if (!result.success) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = result.errorMessage; // e.g. "Email already registered"
    //     });
    //     return;
    //   }
    //
    // No backend is connected yet, so this just simulates a short
    // delay and then navigates straight to Home.
    await Future.delayed(const Duration(milliseconds: 400));
    // ─────────────────────────────────────────────────────────────

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      AppFadeRoute(builder: (_) => const MainShell()),
      (route) => false,
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
                const SizedBox(height: 60),
                const OzziHeader(subtitle: 'Please Sign Up To Your Account'),
                const SizedBox(height: 40),
                SocialButtonsRow(
                  onGoogle: () => _handleSocialTap(context, 'Google'),
                  onFacebook: () => _handleSocialTap(context, 'Facebook'),
                  onApple: () => _handleSocialTap(context, 'Apple'),
                ),
                const SizedBox(height: 32),
                const OrDivider(),
                const SizedBox(height: 28),

                if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),

                OzziTextField(
                  icon: Icons.person,
                  hint: 'Enter Your Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                OzziTextField(
                  icon: Icons.email,
                  hint: 'Enter Your Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                OzziTextField(
                  icon: Icons.lock,
                  hint: 'Enter Your Password',
                  obscureText: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 28),
                OzziPrimaryButton(
                  label: _isLoading ? 'Creating account...' : 'Create Account',
                  onPressed: _isLoading ? () {} : _handleCreateAccount,
                ),

                const SizedBox(height: 60),
                SwitchAuthRow(
                  leading: 'Already Have Account?',
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