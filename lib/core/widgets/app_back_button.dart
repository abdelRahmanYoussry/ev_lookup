import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: Colors.white,
        elevation: 1,
        shadowColor: AppColors.textPrimary.withValues(alpha: 0.2),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
