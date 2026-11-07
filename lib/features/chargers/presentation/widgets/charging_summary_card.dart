import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ChargingSummaryCard extends StatelessWidget {
  const ChargingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CircularProgressIndicator(
                  value: 0.4,
                  strokeWidth: 5,
                  backgroundColor: AppColors.ringTrack,
                  valueColor: AlwaysStoppedAnimation(AppColors.ringValue),
                ),
                Center(child: Text('40', style: text.labelLarge)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Charging 40% → 80%', style: text.titleMedium),
          ),
        ],
      ),
    );
  }
}
