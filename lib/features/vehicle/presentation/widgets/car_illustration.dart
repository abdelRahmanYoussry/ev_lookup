import 'package:flutter/material.dart';

class CarIllustration extends StatelessWidget {
  const CarIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 140,
      width: double.infinity,
      child: CustomPaint(painter: _CarPainter()),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final length = (size.height * 2.6).clamp(0.0, size.width);
    final width = length / 2.6;
    final left = (size.width - length) / 2;
    final top = (size.height - width) / 2;

    RRect box(double x, double y, double w, double h, double r) {
      return RRect.fromRectAndRadius(
        Rect.fromLTWH(left + x * length, top + y * width, w * length, h * width),
        Radius.circular(r * width),
      );
    }

    final wheel = Paint()..color = const Color(0xFF05090F);
    for (final x in [0.16, 0.66]) {
      canvas.drawRRect(box(x, -0.02, 0.16, 0.14, 0.06), wheel);
      canvas.drawRRect(box(x, 0.88, 0.16, 0.14, 0.06), wheel);
    }

    final mirror = Paint()..color = const Color(0xFFE6EBEF);
    canvas.drawRRect(box(0.66, -0.06, 0.06, 0.12, 0.05), mirror);
    canvas.drawRRect(box(0.66, 0.94, 0.06, 0.12, 0.05), mirror);

    canvas.drawRRect(box(0.02, 0.04, 0.96, 0.92, 0.38), Paint()..color = Colors.white);

    final glass = Paint()..color = const Color(0xFF1B2C3A);
    canvas.drawRRect(box(0.28, 0.12, 0.46, 0.76, 0.22), glass);

    canvas.drawRRect(
      box(0.36, 0.2, 0.28, 0.6, 0.16),
      Paint()..color = const Color(0xFFF1F4F7),
    );

    final taillight = Paint()..color = const Color(0xFFE5483A);
    canvas.drawRRect(box(0.03, 0.2, 0.02, 0.16, 0.01), taillight);
    canvas.drawRRect(box(0.03, 0.64, 0.02, 0.16, 0.01), taillight);

    final headlight = Paint()..color = const Color(0xFFBFD7E6);
    canvas.drawRRect(box(0.95, 0.2, 0.02, 0.16, 0.01), headlight);
    canvas.drawRRect(box(0.95, 0.64, 0.02, 0.16, 0.01), headlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
