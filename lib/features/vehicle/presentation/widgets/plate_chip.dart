import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';

String formatPlate(String registration) {
  if (registration.length <= 3) return registration;
  final split = registration.length - 3;
  return '${registration.substring(0, split)} ${registration.substring(split)}';
}

class PlateChip extends StatelessWidget {
  final String registration;

  const PlateChip({super.key, required this.registration});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      height: 36,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.plateYellow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.textPrimary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 24,
            color: AppColors.plateStrip,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              plateCountryCode,
              style: text.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Text(
                formatPlate(registration),
                style: text.titleLarge?.copyWith(
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
