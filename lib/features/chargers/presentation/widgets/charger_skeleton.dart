import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ChargerSkeleton extends StatelessWidget {
  const ChargerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
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
          Divider(height: 1, color: AppColors.neutralTile),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Block(width: 70, height: 28)),
              Expanded(child: _Block(width: 90, height: 28)),
            ],
          ),
        ],
      ),
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
          color: AppColors.neutralTile,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
