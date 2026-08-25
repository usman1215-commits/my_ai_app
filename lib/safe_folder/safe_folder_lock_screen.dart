import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'safe_folder_home_screen.dart';

/// PIN entry gate for the Safe Folder.
///
/// FRONTEND TESTING ONLY:
/// Default temporary PIN is 0000.
/// Replace this with secure local/backend verification later.
class SafeFolderLockScreen extends StatefulWidget {
  /// Temporary frontend PIN.
  /// Change to secure verification when backend is implemented.
  final String correctPin;

  /// When provided, unlocks the Safe Folder inside MainShell
  /// without replacing the entire navigation route.
  final VoidCallback? onUnlocked;

  const SafeFolderLockScreen({
    super.key,
    this.correctPin = '0000',
    this.onUnlocked,
  });

  @override
  State<SafeFolderLockScreen> createState() =>
      _SafeFolderLockScreenState();
}

class _SafeFolderLockScreenState
    extends State<SafeFolderLockScreen> {
  String _entered = '';
  String? _error;

  void _onDigit(String digit) {
    if (_entered.length >= 4) return;

    setState(() {
      _entered += digit;
      _error = null;
    });

    if (_entered.length == 4) {
      _verify();
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;

    setState(() {
      _entered =
          _entered.substring(0, _entered.length - 1);
      _error = null;
    });
  }

  void _verify() {
    // Temporary frontend-only PIN.
    if (_entered == widget.correctPin) {
      if (widget.onUnlocked != null) {
        widget.onUnlocked!();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const SafeFolderHomeScreen(),
          ),
        );
      }
    } else {
      setState(() {
        _error = 'Incorrect PIN';
        _entered = '';
      });
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
              const SizedBox(height: 40),

              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: kFieldColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: kRedColor,
                  size: 28,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Enter PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Enter your PIN to unlock Safe Folder',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.5,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (i) {
                    final filled = i < _entered.length;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? kRedColor
                            : Colors.transparent,
                        border: Border.all(
                          color: filled
                              ? kRedColor
                              : Colors.grey.shade600,
                          width: 1.5,
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: kRedColor,
                    fontSize: 12.5,
                  ),
                ),
              ],

              const Spacer(),

              _NumberPad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  // TODO:
                  // Add biometric authentication later.
                },
                child: Text(
                  'Use biometrics instead',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _NumberPad({
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: row
                  .map(
                    (digit) => _key(
                      digit,
                      () => onDigit(digit),
                    ),
                  )
                  .toList(),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const SizedBox(width: 64),

              _key(
                '0',
                () => onDigit('0'),
              ),

              SizedBox(
                width: 64,
                child: IconButton(
                  onPressed: onBackspace,
                  icon: const Icon(
                    Icons.backspace_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _key(
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kFieldColor,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}