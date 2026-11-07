import 'package:flutter/material.dart';

class CarIllustration extends StatelessWidget {
  const CarIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(painter: _CarPainter()),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  // Length to width of a large electric SUV seen from above.
  static const _aspect = 2.4;

  static const _body = [
    [0.0, 0.30, 0.01, 0.15, 0.05, 0.09],
    [0.09, 0.035, 0.17, 0.02, 0.28, 0.02],
    [0.45, 0.015, 0.65, 0.015, 0.78, 0.02],
    [0.89, 0.025, 0.96, 0.07, 0.985, 0.16],
    [1.0, 0.24, 1.0, 0.40, 1.0, 0.5],
  ];

  static const _glass = [
    [0.27, 0.30, 0.29, 0.15, 0.34, 0.12],
    [0.48, 0.09, 0.64, 0.09, 0.73, 0.12],
    [0.79, 0.15, 0.82, 0.30, 0.82, 0.5],
  ];

  static const _roof = [
    [0.37, 0.32, 0.38, 0.22, 0.42, 0.20],
    [0.52, 0.19, 0.62, 0.19, 0.68, 0.20],
    [0.715, 0.22, 0.72, 0.32, 0.72, 0.5],
  ];

  static const _panorama = [
    [0.44, 0.36, 0.445, 0.30, 0.47, 0.29],
    [0.54, 0.28, 0.62, 0.28, 0.65, 0.29],
    [0.675, 0.30, 0.68, 0.38, 0.68, 0.5],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Leave room above and below the body for the mirrors and the shadow.
    final length = (size.width * 0.78).clamp(0.0, size.height * _aspect / 1.3);
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
    for (final u in [0.16, 0.71]) {
      for (final v in [0.0, 0.92]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect(u, v, u + 0.13, v + 0.08),
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
          colors: [Color(0xFF0E1A24), Color(0xFF24394B), Color(0xFF0E1A24)],
        ).createShader(bounds),
    );

    canvas.drawPath(
      _symmetric(p, _roof),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDE3E8), Colors.white, Color(0xFFDDE3E8)],
        ).createShader(bounds),
    );

    canvas.drawPath(
      _symmetric(p, _panorama),
      Paint()..color = const Color(0xFF16232E),
    );

    final crease =
        Paint()
          ..color = const Color(0xFFD5DCE2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    canvas.drawLine(p(0.81, 0.30), p(0.96, 0.25), crease);
    canvas.drawLine(p(0.81, 0.70), p(0.96, 0.75), crease);

    final mirror = Paint()..color = const Color(0xFFE9EDF1);
    final mirrorEdge =
        Paint()
          ..color = const Color(0xFFC9D1D9)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    for (final v in [-0.075, 0.965]) {
      final shape = RRect.fromRectAndRadius(
        rect(0.66, v, 0.71, v + 0.11),
        Radius.circular(width * 0.04),
      );
      canvas.drawRRect(shape, mirror);
      canvas.drawRRect(shape, mirrorEdge);
    }

    final headlight = Paint()..color = const Color(0xFF9FC3DA);
    for (final v in [0.16, 0.66]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect(0.94, v, 0.968, v + 0.18),
          Radius.circular(width * 0.02),
        ),
        headlight,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect(0.022, 0.18, 0.034, 0.82),
        Radius.circular(width * 0.01),
      ),
      Paint()..color = const Color(0xFFE5483A),
    );
  }

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
