import 'package:flutter/material.dart';

class LedgerWordmark extends StatelessWidget {
  const LedgerWordmark({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LedgerMark(),
        const SizedBox(width: 9),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Kankoo',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -0.9),
            ),
          ),
        ),
      ],
    );
  }
}

class LedgerMark extends StatelessWidget {
  const LedgerMark({super.key});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF263775), Color(0xFF465AC2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: CustomPaint(painter: _LedgerMarkPainter()),
    ),
  );
}

class _LedgerMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final w = size.width, h = size.height;
    canvas.drawPath(
      Path()
        ..moveTo(w * .2, h * .12)
        ..lineTo(w * .2, h * .88)
        ..moveTo(w * .8, h * .12)
        ..lineTo(w * .2, h * .52)
        ..lineTo(w * .8, h * .88),
      stroke,
    );
    canvas.drawCircle(Offset(w * .81, h * .49), w * .095, Paint()..color = const Color(0xFFC3F0DE));
  }

  @override
  bool shouldRepaint(covariant _LedgerMarkPainter oldDelegate) => false;
}

class LedgerEyebrow extends StatelessWidget {
  const LedgerEyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w700),
  );
}

/// Decorative statement-to-evidence artwork; contains no ledger data.
class LedgerEvidenceIllustration extends StatelessWidget {
  const LedgerEvidenceIllustration({super.key});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: 104,
      child: CustomPaint(
        painter: _EvidencePainter(
          paper: Theme.of(context).colorScheme.surface,
          line: Theme.of(context).colorScheme.outlineVariant,
          ink: Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
  );
}

class _EvidencePainter extends CustomPainter {
  const _EvidencePainter({required this.paper, required this.line, required this.ink});
  final Color paper, line, ink;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2 - 135, 0);
    final fill = Paint()..color = paper;
    final border = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rule = Paint()
      ..color = ink.withValues(alpha: .3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    void sheet(double x, double y, double angle) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      final rect = RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 70, 82), const Radius.circular(9));
      canvas.drawRRect(rect, fill);
      canvas.drawRRect(rect, border);
      canvas.drawLine(
        const Offset(13, 18),
        const Offset(31, 18),
        Paint()
          ..color = ink
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
      for (var i = 0; i < 3; i++) {
        canvas.drawLine(Offset(13, 35 + i * 11), Offset(i == 2 ? 40 : 55, 35 + i * 11), rule);
      }
      canvas.restore();
    }

    sheet(32, 16, -.13);
    canvas.drawLine(
      const Offset(99, 48),
      const Offset(170, 48),
      Paint()
        ..color = ink.withValues(alpha: .3)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(const Offset(135, 48), 13, Paint()..color = ink);
    canvas.drawPath(
      Path()
        ..moveTo(130, 48)
        ..lineTo(140, 48)
        ..moveTo(136, 44)
        ..lineTo(140, 48)
        ..lineTo(136, 52),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.7
        ..strokeCap = StrokeCap.round,
    );
    sheet(171, 8, .1);
    canvas.drawCircle(const Offset(233, 76), 17, Paint()..color = const Color(0xFFC3F0DE));
    canvas.drawPath(
      Path()
        ..moveTo(226, 76)
        ..lineTo(231, 81)
        ..lineTo(240, 71),
      Paint()
        ..color = const Color(0xFF11594C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EvidencePainter oldDelegate) =>
      paper != oldDelegate.paper || line != oldDelegate.line || ink != oldDelegate.ink;
}
