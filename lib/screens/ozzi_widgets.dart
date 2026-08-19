import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFF202020);
const kFieldColor = Color(0xFF2E2E2E);
const kRedColor = Color(0xFFE0392B);
const kSocialBtnColor = Color(0xFF3A3A3A);

/// Keeps content at a phone-like width and centers it.
///
/// This app targets Android/iOS only — on a real phone, the screen
/// is already narrow, so this has zero visual effect there. It only
/// matters when previewing with `flutter run -d chrome` / web-server
/// on a wide PC browser, where it stops the layout from stretching
/// edge-to-edge and instead shows it like a centered phone mockup.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double maxWidth;

  const PhoneFrame({
    super.key,
    required this.child,
    this.backgroundColor = kBackgroundColor,
    this.maxWidth = 430,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The "Ozzi" wordmark + subtitle used at the top of both screens.
class OzziHeader extends StatelessWidget {
  final String subtitle;

  const OzziHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Ozzi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontFamily: 'serif',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
      ],
    );
  }
}

/// Row of 3 square social login icon buttons (Google / Facebook / Apple).
class SocialButtonsRow extends StatelessWidget {
  final VoidCallback? onGoogle;
  final VoidCallback? onFacebook;
  final VoidCallback? onApple;

  const SocialButtonsRow({
    super.key,
    this.onGoogle,
    this.onFacebook,
    this.onApple,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(onTap: onGoogle, child: const Text('G', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(width: 16),
        _SocialIconButton(onTap: onFacebook, child: const Icon(Icons.facebook, color: Colors.white, size: 24)),
        const SizedBox(width: 16),
        _SocialIconButton(onTap: onApple, child: const Icon(Icons.apple, color: Colors.white, size: 26)),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SocialIconButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSocialBtnColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(width: 76, height: 68, child: Center(child: child)),
      ),
    );
  }
}

/// "──── or ────" divider.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade600, thickness: 0.6)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade600, thickness: 0.6)),
      ],
    );
  }
}

/// Dark rounded input field with a leading icon, matching the mockup.
class OzziTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;

  const OzziTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: kFieldColor,
        borderRadius: BorderRadius.circular(27),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: kRedColor, size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

/// Solid red rounded call-to-action button.
class OzziPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const OzziPrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kRedColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// Bottom "Don't have an account? Sign up" style row.
class SwitchAuthRow extends StatelessWidget {
  final String leading;
  final String action;
  final VoidCallback onTap;

  const SwitchAuthRow({
    super.key,
    required this.leading,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 13),
            children: [
              TextSpan(text: '$leading ', style: const TextStyle(color: Colors.white)),
              TextSpan(text: action, style: const TextStyle(color: kRedColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple back-arrow button used at the top of secondary screens
/// (forgot password / OTP / reset password) that sit on top of Login.
class OzziBackButton extends StatelessWidget {
  const OzziBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        style: IconButton.styleFrom(
          backgroundColor: kSocialBtnColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

/// Shows a backend/validation error message (e.g. "Incorrect email or
/// password"). Pass null/empty to hide it — nothing is hardcoded here,
/// the message always comes from whatever your API call returns.
///
/// Usage:
///   String? _errorMessage;
///   ...
///   if (_errorMessage != null) OzziErrorBanner(message: _errorMessage!),
class OzziErrorBanner extends StatelessWidget {
  final String message;

  const OzziErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kRedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kRedColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: kRedColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: kRedColor, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of boxed single-digit fields for OTP / verification code entry.
class OzziOtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final ValueChanged<String>? onCompleted;

  const OzziOtpRow({
    super.key,
    required this.controllers,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final focusNodes = List.generate(controllers.length, (_) => FocusNode());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(controllers.length, (i) {
        return SizedBox(
          width: 56,
          height: 62,
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: kFieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kRedColor, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && i < controllers.length - 1) {
                focusNodes[i + 1].requestFocus();
              }
              if (value.isEmpty && i > 0) {
                focusNodes[i - 1].requestFocus();
              }
              final code = controllers.map((c) => c.text).join();
              if (code.length == controllers.length) {
                onCompleted?.call(code);
              }
            },
          ),
        );
      }),
    );
  }
}