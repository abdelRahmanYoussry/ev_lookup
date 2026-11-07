import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CarIllustration extends StatelessWidget {
  const CarIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      width: double.infinity,
      child: CustomPaint(painter: _CarPainter()),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  // Length to width of a large electric SUV seen from above.
  static const _aspect = 2.6;

  static const _body = [
    [0.0, 0.25, 0.04, 0.06, 0.14, 0.04],
    [0.35, 0.0, 0.70, 0.0, 0.86, 0.03],
    [0.95, 0.06, 1.0, 0.22, 1.0, 0.5],
  ];

  static const _glass = [
    [0.18, 0.30, 0.185, 0.17, 0.24, 0.14],
    [0.40, 0.125, 0.62, 0.125, 0.72, 0.14],
    [0.77, 0.16, 0.78, 0.32, 0.78, 0.5],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Leave room above and below the body for the mirrors and the shadow.
    final length = (size.width * 0.8).clamp(0.0, size.height * _aspect / 1.3);
    final width = length / _aspect;
    final origin = Offset((size.width - length) / 2, (size.height - width) / 2);
    Offset p(double u, double v) => origin + Offset(u * length, v * width);
    Rect rect(double u1, double v1, double u2, double v2) =>
        Rect.fromPoints(p(u1, v1), p(u2, v2));
    final bounds = rect(0, 0, 1, 1);

    final body = _symmetric(p, _body);

    canvas.drawPath(
      body.shift(Offset(0, width * 0.06)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, width * 0.08),
    );

    final tyre = Paint()..color = const Color(0xFF05090F);
    for (final u in [0.16, 0.69]) {
      for (final (v1, v2) in [(-0.08, 0.04), (0.96, 1.08)]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect(u, v1, u + 0.15, v2),
            Radius.circular(width * 0.03),
          ),
          tyre,
        );
      }
    }

    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC9D1D9),
            Color(0xFFF4F6F8),
            Colors.white,
            Color(0xFFF4F6F8),
            Color(0xFFC9D1D9),
          ],
          stops: [0, 0.18, 0.5, 0.82, 1],
        ).createShader(bounds),
    );

    canvas.drawPath(
      _symmetric(p, _glass),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0C121C), Color(0xFF151D2B), Color(0xFF2B3852)],
          stops: [0, 0.6, 1],
        ).createShader(bounds),
    );

    final line =
        Paint()
          ..color = const Color(0xFF46566A)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect(0.30, 0.22, 0.61, 0.78),
        Radius.circular(width * 0.13),
      ),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(0.27, 0.17).dx, p(0.27, 0.17).dy)
        ..quadraticBezierTo(
          p(0.235, 0.5).dx,
          p(0.235, 0.5).dy,
          p(0.27, 0.83).dx,
          p(0.27, 0.83).dy,
        ),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(0.655, 0.17).dx, p(0.655, 0.17).dy)
        ..quadraticBezierTo(
          p(0.69, 0.5).dx,
          p(0.69, 0.5).dy,
          p(0.655, 0.83).dx,
          p(0.655, 0.83).dy,
        ),
      line,
    );

    final crease =
        Paint()
          ..color = const Color(0xFFD5DCE2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    for (final flip in [false, true]) {
      Offset q(double u, double v) => p(u, flip ? 1 - v : v);
      final start = q(0.80, 0.33);
      final c1 = q(0.86, 0.30);
      final c2 = q(0.90, 0.36);
      final end = q(0.96, 0.33);
      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy),
        crease,
      );
    }

    final mirror = Paint()..color = const Color(0xFFE9EDF1);
    for (final (v1, v2) in [(-0.075, 0.03), (0.97, 1.075)]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect(0.65, v1, 0.685, v2),
          Radius.circular(width * 0.05),
        ),
        mirror,
      );
    }

    canvas.drawPath(
      _quad(p(0.975, 0.22), p(1.005, 0.5), p(0.975, 0.78)),
      Paint()
        ..color = const Color(0xFFBFDDF0)
        ..strokeWidth = width * 0.018
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawPath(
      _quad(p(0.04, 0.16), p(0.0, 0.5), p(0.04, 0.84)),
      Paint()
        ..color = const Color(0xFFE8562F)
        ..strokeWidth = width * 0.02
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawCircle(
      p(0.20, 0.07),
      width * 0.022,
      Paint()..color = AppColors.buttonEnd,
    );
  }

  Path _quad(Offset from, Offset control, Offset to) =>
      Path()
        ..moveTo(from.dx, from.dy)
        ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);

  // Each segment is [c1u, c1v, c2u, c2v, u, v] along the top half, from the
  // rear centre line to the front one. The bottom half mirrors it. The start
  // shares its u with the first control point so the rear edge stays smooth.
  Path _symmetric(
    Offset Function(double u, double v) p,
    List<List<double>> top,
  ) {
    final start = p(top.first[0], 0.5);
    final path = Path()..moveTo(start.dx, start.dy);
    for (final s in top) {
      final c1 = p(s[0], s[1]);
      final c2 = p(s[2], s[3]);
      final end = p(s[4], s[5]);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
    }
    for (var i = top.length - 1; i >= 0; i--) {
      final s = top[i];
      final c1 = p(s[2], 1 - s[3]);
      final c2 = p(s[0], 1 - s[1]);
      final end = i == 0 ? start : p(top[i - 1][4], 1 - top[i - 1][5]);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
