import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.buttonHeight / 2);

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              colors: [
                AppColors.buttonStart,
                AppColors.buttonMiddle,
                AppColors.buttonEnd,
              ],
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: SizedBox(
              height: AppSpacing.buttonHeight,
              width: double.infinity,
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
