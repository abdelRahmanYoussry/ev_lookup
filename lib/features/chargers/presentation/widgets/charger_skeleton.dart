import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ChargerSkeleton extends StatefulWidget {
  const ChargerSkeleton({super.key});

  @override
  State<ChargerSkeleton> createState() => _ChargerSkeletonState();
}

class _ChargerSkeletonState extends State<ChargerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) => ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: const [
                      AppColors.ringTrack,
                      AppColors.neutralTile,
                      AppColors.ringTrack,
                    ],
                    stops: const [0.35, 0.5, 0.65],
                    transform: _SlideTransform(_controller.value * 2 - 1),
                  ).createShader(bounds),
              child: child,
            ),
        child: const _Placeholder(),
      ),
    );
  }
}

class _SlideTransform extends GradientTransform {
  final double percent;

  const _SlideTransform(this.percent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Block(width: 28, height: 28),
            SizedBox(width: 10),
            _Block(width: 160, height: 18),
          ],
        ),
        SizedBox(height: 10),
        _Block(width: 200, height: 12),
        SizedBox(height: 12),
        Divider(height: 1, color: Colors.white),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _Block(width: 70, height: 28)),
            Expanded(child: _Block(width: 90, height: 28)),
          ],
        ),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  final double width;
  final double height;

  const _Block({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
