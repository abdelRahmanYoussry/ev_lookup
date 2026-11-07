import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/charger.dart';

class ChargerCard extends StatelessWidget {
  final Charger charger;

  const ChargerCard({super.key, required this.charger});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

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
            l10n.chargerDetails(
              charger.powerKw,
              charger.connector,
              charger.freeBays,
              charger.totalBays,
            ),
            style: text.bodyMedium,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutralTile),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.chargerTimeLabel,
                  value: l10n.minutesValue(charger.minutes),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: l10n.chargerTotalLabel,
                  value: l10n.totalValue(charger.totalGbp),
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
