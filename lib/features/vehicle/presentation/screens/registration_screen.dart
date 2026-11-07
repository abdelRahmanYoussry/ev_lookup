import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/vehicle_lookup_cubit.dart';
import '../cubit/vehicle_lookup_state.dart';
import '../widgets/plate_input.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<VehicleLookupCubit>().lookup(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return BlocConsumer<VehicleLookupCubit, VehicleLookupState>(
      listenWhen: (_, current) => current is VehicleLookupSuccess,
      listener: (context, state) async {
        if (state is! VehicleLookupSuccess) return;
        final cubit = context.read<VehicleLookupCubit>();
        await Navigator.of(context).pushNamed(
          AppRoutes.confirmation,
          arguments: state,
        );
        if (context.mounted) cubit.reset();
      },
      builder: (context, state) {
        final message = switch (state) {
          VehicleLookupValidationError(:final message) ||
          VehicleLookupNotFound(:final message) ||
          VehicleLookupFailed(:final message) =>
            message,
          _ => null,
        };
        final loading = state is VehicleLookupLoading;

        return Scaffold(
          body: GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                    child: Center(
                      child: Text('Add your EV', style: text.titleMedium),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.gutter,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text('STEP 1 OF 2', style: text.labelSmall),
                          const SizedBox(height: 8),
                          Text(
                            "What's your registration?",
                            style: text.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We look up your car so charging shows only '
                            'chargers that fit, with real time and cost.',
                            style: text.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          PlateInput(
                            controller: _controller,
                            onSubmitted: (_) => _submit(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message ?? 'Check the plate on the back of your car.',
                            style: message == null
                                ? text.bodySmall
                                : text.bodySmall?.copyWith(
                                    color: AppColors.error,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: PrimaryButton(
                      label: 'Find my EV',
                      onPressed: loading ? null : () => _submit(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
