import 'package:flutter/material.dart';

import '../core/theme/palette.dart';

/// The Kankoo app icon: a white "K" with a mint coin, on the brand
/// gradient. Same geometry and colours as the launcher icon
/// (tool/gen_brand_assets.js, assets/branding/kankoo-icon.svg).
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * 0.28),
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MarkPainter()),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  // Unit-square geometry, shared with the icon generator.
  static const stemX = 0.400, top = 0.305, bottom = 0.695, stroke = 0.082;
  static const armX = 0.595, armY = 0.315, joinY = 0.520;
  static const legX = 0.472, legY = 0.447, footX = 0.603, footY = 0.690;
  static const coinX = 0.605, coinY = 0.480, coinR = 0.038;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B7CF6), Color(0xFF5B4BE0), Color(0xFF2A2380)],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );
    canvas.save();
    // Like the launcher, which shows the inner 72dp of the 108dp canvas.
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(size.shortestSide * 1.4);
    canvas.translate(-0.5, -0.5);

    final p = Path()
      ..moveTo(stemX, bottom)
      ..lineTo(stemX, top)
      ..moveTo(armX, armY)
      ..lineTo(stemX, joinY)
      ..moveTo(legX, legY)
      ..lineTo(footX, footY);
    canvas.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
    canvas.drawCircle(const Offset(coinX, coinY), coinR, Paint()..color = Palette.mint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
