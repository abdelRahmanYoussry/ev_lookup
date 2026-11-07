import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PlateInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const PlateInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final plateStyle = text.headlineMedium?.copyWith(
      fontSize: 30,
      letterSpacing: 1,
    );

    return Container(
      height: 68,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.plateYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textPrimary, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40,
            color: AppColors.plateStrip,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'UK',
              style: text.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: TextField(
                controller: controller,
                onSubmitted: onSubmitted,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,
                maxLines: 1,
                cursorColor: AppColors.textPrimary,
                style: plateStyle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'TF24 LPO',
                  hintStyle: plateStyle?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
