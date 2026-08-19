import 'package:flutter/material.dart';
import 'ozzi_widgets.dart';
import 'login_screen.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PhoneFrame(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: kRedColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Password Changed!',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your password has been changed\nsuccessfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 40),
                OzziPrimaryButton(
                  label: 'Back to Login',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}