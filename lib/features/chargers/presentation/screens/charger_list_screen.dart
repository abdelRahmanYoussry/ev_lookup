import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../cubit/chargers_cubit.dart';
import '../cubit/chargers_state.dart';
import '../widgets/charger_card.dart';
import '../widgets/charger_skeleton.dart';
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
          ChargersEmpty() => '0 chargers near you',
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
      ChargersLoading() => _list([
          for (var i = 0; i < 3; i++) const ChargerSkeleton(),
        ]),
      ChargersLoaded(:final chargers) => _list([
          for (final charger in chargers) ChargerCard(charger: charger),
        ]),
      ChargersEmpty() => _Message(
          title: 'No compatible chargers',
          body: 'We could not find any chargers that fit your car.',
          button: SecondaryButton(
            label: 'Go back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ChargersFailure(:final message) => _Message(
          title: 'Could not load chargers',
          body: message,
          button: PrimaryButton(
            label: 'Retry',
            onPressed: () => context.read<ChargersCubit>().retry(),
          ),
        ),
    };
  }

  Widget _list(List<Widget> cards) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.gutter,
      ),
      children: [
        const ChargingSummaryCard(),
        for (final card in cards) ...[const SizedBox(height: 12), card],
      ],
    );
  }
}

class _Message extends StatelessWidget {
  final String title;
  final String body;
  final Widget button;

  const _Message({
    required this.title,
    required this.body,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: text.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body,
                    style: text.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: button,
        ),
      ],
    );
  }
}
