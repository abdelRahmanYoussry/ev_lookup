import 'package:flutter/material.dart';

class CarIllustration extends StatelessWidget {
  const CarIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 96,
      width: double.infinity,
      child: CustomPaint(painter: _CarPainter()),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  static const _aspect = 3.4;

  @override
  void paint(Canvas canvas, Size size) {
    final length = (size.width * 0.85).clamp(0.0, size.height * _aspect);
    final width = length / _aspect;
    final left = (size.width - length) / 2;
    final top = (size.height - width) / 2;

    RRect box(double x, double y, double w, double h, double r) {
      return RRect.fromRectAndRadius(
        Rect.fromLTWH(left + x * length, top + y * width, w * length, h * width),
        Radius.circular(r * width),
      );
    }

    final wheel = Paint()..color = const Color(0xFF05090F);
    for (final x in [0.17, 0.68]) {
      canvas.drawRRect(box(x, -0.01, 0.15, 0.1, 0.05), wheel);
      canvas.drawRRect(box(x, 0.91, 0.15, 0.1, 0.05), wheel);
    }

    final mirror = Paint()..color = const Color(0xFFE6EBEF);
    canvas.drawRRect(box(0.68, -0.05, 0.05, 0.1, 0.05), mirror);
    canvas.drawRRect(box(0.68, 0.95, 0.05, 0.1, 0.05), mirror);

    canvas.drawRRect(
      box(0.01, 0.06, 0.98, 0.88, 0.44),
      Paint()..color = Colors.white,
    );

    canvas.drawRRect(
      box(0.27, 0.17, 0.48, 0.66, 0.33),
      Paint()..color = const Color(0xFF1B2C3A),
    );

    canvas.drawRRect(
      box(0.35, 0.25, 0.32, 0.5, 0.25),
      Paint()..color = const Color(0xFFF1F4F7),
    );

    final taillight = Paint()..color = const Color(0xFFE5483A);
    canvas.drawRRect(box(0.035, 0.22, 0.015, 0.14, 0.01), taillight);
    canvas.drawRRect(box(0.035, 0.64, 0.015, 0.14, 0.01), taillight);

    final headlight = Paint()..color = const Color(0xFFBFD7E6);
    canvas.drawRRect(box(0.95, 0.22, 0.015, 0.14, 0.01), headlight);
    canvas.drawRRect(box(0.95, 0.64, 0.015, 0.14, 0.01), headlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
