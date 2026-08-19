import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import '../navigation/app_page_route.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../navigation/main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Backend-driven state — nothing hardcoded. _errorMessage stays null
  // until your real API call sets it (e.g. "Incorrect email or password").
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSocialTap(BuildContext context, String provider) {
    // TODO: replace with real Google/Facebook/Apple sign-in logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider login tapped')),
    );
  }

  void _goToForgotPassword() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(AppPageRoute(builder: (_) => const ForgotPasswordScreen()));
  }

  void _goToRegister() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(AppPageRoute(builder: (_) => const RegisterScreen()));
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // ─────────────────────────────────────────────────────────────
    // TODO: replace this whole block with your real login API call.
    // Example shape of what it should look like:
    //
    //   final result = await AuthApi.login(
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text,
    //   );
    //   if (!result.success) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = result.errorMessage; // e.g. "Incorrect email or password"
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
                const OzziHeader(subtitle: 'Please Login To Your Account'),
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

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _goToForgotPassword,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Forget Password?',
                      style: TextStyle(color: kRedColor, fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                OzziPrimaryButton(
                  label: _isLoading ? 'Logging in...' : 'Login',
                  onPressed: _isLoading ? () {} : _handleLogin,
                ),

                const SizedBox(height: 60),
                SwitchAuthRow(
                  leading: "Don't Have Account?",
                  action: 'Sign Up',
                  onTap: _goToRegister,
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