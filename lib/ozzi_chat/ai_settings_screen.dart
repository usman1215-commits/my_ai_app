import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';

/// FRONTEND ONLY — all toggle states below are just local UI state
/// (setState). None of this is persisted or connected to a backend.
/// Wire up real save/load logic (SharedPreferences, Firebase, your
/// API, etc.) wherever the // TODO comments are.
class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  // Toggle placeholders — replace with real persisted values later.
  bool _anonymousMode = false;
  bool _temporaryChat = false;
  bool _memory = true;
  bool _voiceMode = false;
  bool _wakeWord = false;
  bool _alwaysListening = false;
  bool _webSearch = true;
  bool _imageGeneration = true;
  bool _imageAnalysis = true;
  bool _ocr = false;
  bool _pdfChat = true;

  final String _personality = 'Friendly';
  double _responseLength = 0.5; // 0 = short, 1 = long
  double _creativity = 0.5; // 0 = focused, 1 = creative

  void _placeholderTap(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label tapped — hook up backend later')),
    );
  }

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
                  children: const [
                    OzziBackButton(),
                    SizedBox(width: 12),
                    Text('AI Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    _SectionLabel('Privacy'),
                    _toggleTile('Anonymous Mode', Icons.visibility_off_outlined, _anonymousMode, (v) => setState(() => _anonymousMode = v)),
                    _toggleTile('Temporary Chat', Icons.timer_outlined, _temporaryChat, (v) => setState(() => _temporaryChat = v)),
                    _toggleTile('Memory', Icons.psychology_outlined, _memory, (v) => setState(() => _memory = v)),

                    _SectionLabel('Voice'),
                    _toggleTile('Voice Mode', Icons.graphic_eq_rounded, _voiceMode, (v) => setState(() => _voiceMode = v)),
                    _toggleTile('Wake Word ("Hey Ozzi")', Icons.record_voice_over_outlined, _wakeWord, (v) => setState(() => _wakeWord = v)),
                    _toggleTile('Always Listening', Icons.hearing, _alwaysListening, (v) => setState(() => _alwaysListening = v)),

                    _SectionLabel('AI Behavior'),
                    _navTile('AI Personality', Icons.face_retouching_natural, trailingText: _personality, onTap: () => _placeholderTap('AI Personality')),
                    _sliderTile('Response Length', Icons.short_text, _responseLength, (v) => setState(() => _responseLength = v)),
                    _sliderTile('Creativity', Icons.auto_awesome, _creativity, (v) => setState(() => _creativity = v)),

                    _SectionLabel('Capabilities'),
                    _toggleTile('Web Search', Icons.public, _webSearch, (v) => setState(() => _webSearch = v)),
                    _toggleTile('Image Generation', Icons.image_outlined, _imageGeneration, (v) => setState(() => _imageGeneration = v)),
                    _toggleTile('Image Analysis', Icons.image_search, _imageAnalysis, (v) => setState(() => _imageAnalysis = v)),
                    _toggleTile('OCR', Icons.document_scanner_outlined, _ocr, (v) => setState(() => _ocr = v)),
                    _toggleTile('PDF Chat', Icons.picture_as_pdf_outlined, _pdfChat, (v) => setState(() => _pdfChat = v)),

                    _SectionLabel('Advanced'),
                    _navTile('API Keys', Icons.vpn_key_outlined, onTap: () => _placeholderTap('API Keys')),
                    _navTile('Custom Instructions', Icons.edit_note, onTap: () => _placeholderTap('Custom Instructions')),
                    _navTile('Clear Chat History', Icons.delete_outline, isDestructive: true, onTap: () => _placeholderTap('Clear Chat History')),
                    _navTile('Export Data', Icons.download_outlined, onTap: () => _placeholderTap('Export Data')),
                    _navTile('Developer Options', Icons.code, onTap: () => _placeholderTap('Developer Options')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleTile(String label, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: kRedColor,
        inactiveTrackColor: const Color(0xFF3A3A3A),
        secondary: Icon(icon, color: Colors.white70, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
      ),
    );
  }

  Widget _navTile(String label, IconData icon, {String? trailingText, bool isDestructive = false, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isDestructive ? kRedColor : Colors.white70, size: 20),
        title: Text(
          label,
          style: TextStyle(color: isDestructive ? kRedColor : Colors.white, fontSize: 13.5),
        ),
        trailing: trailingText != null
            ? Text(trailingText, style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5))
            : Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      ),
    );
  }

  Widget _sliderTile(String label, IconData icon, double value, ValueChanged<double> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kRedColor,
              inactiveTrackColor: const Color(0xFF3A3A3A),
              thumbColor: Colors.white,
              overlayColor: kRedColor.withValues(alpha: 0.2),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }
}