import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/vehicle.dart';
import '../widgets/car_illustration.dart';
import '../widgets/plate_chip.dart';

class ConfirmationScreen extends StatelessWidget {
  final Vehicle vehicle;
  final String registration;

  const ConfirmationScreen({
    super.key,
    required this.vehicle,
    required this.registration,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 64,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('Is this your car?', style: text.titleMedium),
                    const Positioned(
                      left: AppSpacing.gutter,
                      child: AppBackButton(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.gutter,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.cardRadius,
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.heroTop, AppColors.heroBottom],
                          ),
                        ),
                        child: Column(
                          children: [
                            const CarIllustration(),
                            const SizedBox(height: 16),
                            Text(
                              '${vehicle.make} ${vehicle.model}',
                              textAlign: TextAlign.center,
                              style: text.titleLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            PlateChip(registration: registration),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            _DetailRow(label: 'Year', value: '${vehicle.year}'),
                            const _RowDivider(),
                            _DetailRow(
                              label: 'Battery',
                              value: '${vehicle.batteryKwh} kWh',
                            ),
                            const _RowDivider(),
                            _DetailRow(
                              label: 'Connector',
                              value: vehicle.connector,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: 'Yes, add my EV',
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.chargers,
                        arguments: vehicle.connector,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SecondaryButton(
                      label: 'Not my car',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text.bodyMedium),
          Text(value, style: text.labelLarge),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.neutralTile);
  }
}
