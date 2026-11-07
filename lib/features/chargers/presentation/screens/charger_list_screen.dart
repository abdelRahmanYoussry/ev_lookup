import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../cubit/chargers_cubit.dart';
import '../cubit/chargers_state.dart';
import '../widgets/charger_card.dart';
import '../widgets/charging_summary_card.dart';

class ChargerListScreen extends StatelessWidget {
  const ChargerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return BlocBuilder<ChargersCubit, ChargersState>(
      builder: (context, state) {
        final heading = switch (state) {
          ChargersLoaded(:final chargers) when chargers.length == 1 =>
            '1 charger near you',
          ChargersLoaded(:final chargers) =>
            '${chargers.length} chargers near you',
          _ => 'Chargers near you',
        };

        return Scaffold(
          body: GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: Row(
                      children: [
                        const AppBackButton(),
                        const SizedBox(width: 12),
                        Expanded(child: Text(heading, style: text.titleMedium)),
                      ],
                    ),
                  ),
                  Expanded(child: _Body(state: state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final ChargersState state;

  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ChargersLoading() => const Center(child: CircularProgressIndicator()),
      ChargersLoaded(:final chargers) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.gutter,
          ),
          children: [
            const ChargingSummaryCard(),
            for (final charger in chargers) ...[
              const SizedBox(height: 12),
              ChargerCard(charger: charger),
            ],
          ],
        ),
      ChargersEmpty() => const Center(child: Text('No compatible chargers')),
      ChargersFailure(:final message) => Center(child: Text(message)),
    };
  }
}
