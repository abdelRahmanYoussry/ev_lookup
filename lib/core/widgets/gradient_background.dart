import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 320,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.headerStart,
                  AppColors.headerEnd,
                  AppColors.pageBackground,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
