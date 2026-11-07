import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/charger.dart';

class ChargerCard extends StatelessWidget {
  final Charger charger;

  const ChargerCard({super.key, required this.charger});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.chargerIcon,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bolt, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  charger.name,
                  style: text.titleMedium?.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${charger.powerKw} kW · ${charger.connector} · '
            '${charger.freeBays} of ${charger.totalBays} free',
            style: text.bodyMedium,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutralTile),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Stat(label: 'TIME', value: '${charger.minutes} min'),
              ),
              Expanded(
                child: _Stat(
                  label: 'TOTAL',
                  value: '£${charger.totalGbp.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(value, style: text.titleLarge),
      ],
    );
  }
}
