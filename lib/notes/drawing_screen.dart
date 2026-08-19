// Placeholder for drawing screen.
import 'package:flutter/material.dart';
import '../screens/ozzi_widgets.dart';
import 'note_models.dart';

/// Freehand drawing canvas — color picker, stroke width, undo, clear.
/// FRONTEND ONLY — drawing is captured in-memory below; wire up real
/// export-to-image + save-to-backend where marked.
class DrawingScreen extends StatefulWidget {
  final Note? note;

  const DrawingScreen({super.key, this.note});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _Stroke {
  final List<Offset> points;
  final Color color;
  final double width;
  _Stroke({required this.points, required this.color, required this.width});
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<_Stroke> _strokes = [];
  Color _selectedColor = Colors.white;
  double _strokeWidth = 4;

  static const _colors = [Colors.white, kRedColor, Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFFF9800)];

  void _onPanStart(DragStartDetails details) {
    setState(() => _strokes.add(_Stroke(points: [details.localPosition], color: _selectedColor, width: _strokeWidth)));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() => _strokes.last.points.add(details.localPosition));
  }

  void _undo() {
    if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
  }

  void _clear() => setState(() => _strokes.clear());

  void _save() {
    // TODO: render the strokes to an image and save it (+ note title)
    // to your real backend/local database here.
    Navigator.of(context).pop();
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
                padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
                child: Row(
                  children: [
                    const OzziBackButton(),
                    const Spacer(),
                    IconButton(onPressed: _undo, icon: const Icon(Icons.undo, color: Colors.white70, size: 20)),
                    IconButton(onPressed: _clear, icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 20)),
                    TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(color: kRedColor, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.antiAlias,
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    child: CustomPaint(
                      painter: _DrawingPainter(_strokes),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ..._colors.map((c) => GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: _selectedColor == c ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                          ),
                        )),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _strokeWidth,
                        min: 1,
                        max: 16,
                        activeColor: kRedColor,
                        inactiveColor: Colors.grey.shade700,
                        onChanged: (v) => setState(() => _strokeWidth = v),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<_Stroke> strokes;
  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (var i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}