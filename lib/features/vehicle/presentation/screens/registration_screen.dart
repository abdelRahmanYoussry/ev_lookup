import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/failure_message.dart';
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

  void _retry(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<VehicleLookupCubit>().retry();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<VehicleLookupCubit, VehicleLookupState>(
      listenWhen: (_, current) => current is VehicleLookupSuccess,
      listener: (context, state) async {
        if (state is! VehicleLookupSuccess) return;
        final cubit = context.read<VehicleLookupCubit>();
        await Navigator.of(context).pushNamed(AppRoutes.confirmation, arguments: state);
        if (context.mounted) cubit.reset();
      },
      builder: (context, state) {
        final message = switch (state) {
          VehicleLookupValidationError() => l10n.enterRegistration,
          VehicleLookupNotFound() => l10n.vehicleNotFound,
          VehicleLookupFailed(:final failure) => l10n.failureMessage(failure),
          _ => null,
        };
        final loading = state is VehicleLookupLoading;

        return Scaffold(
          body: GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 64, child: Center(child: Text(l10n.registrationTitle, style: text.titleMedium))),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(l10n.registrationStep, style: text.labelSmall),
                          const SizedBox(height: 8),
                          Text(l10n.registrationHeading, style: text.headlineMedium),
                          const SizedBox(height: 8),
                          Text(l10n.registrationSubtitle, style: text.bodyMedium),
                          const SizedBox(height: 20),
                          PlateInput(controller: _controller, onSubmitted: (_) => _submit(context)),
                          const SizedBox(height: 8),
                          if (message == null)
                            Text(l10n.registrationHelper, style: text.bodySmall)
                          else
                            Row(
                              children: [
                                Expanded(child: Text(message, style: text.bodySmall?.copyWith(color: AppColors.error))),
                                if (state is VehicleLookupFailed)
                                  TextButton(
                                    onPressed: () => _retry(context),
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(0, 32),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(l10n.retry, style: text.labelLarge),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(AppSpacing.gutter), child: PrimaryButton(label: l10n.findMyEv, onPressed: loading ? null : () => _submit(context))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
