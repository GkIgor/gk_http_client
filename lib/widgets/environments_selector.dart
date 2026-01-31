import 'package:flutter/material.dart';
import 'package:gk_http_client/theme/app_colors.dart';

class EnvironmentsSelector extends StatelessWidget {
  const EnvironmentsSelector({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : AppColors.slate100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: _EnvironmentsSelector(isDark: isDark, name: 'Default Env'),
    );
  }
}

class _EnvironmentsSelector extends StatelessWidget {
  const _EnvironmentsSelector({required this.isDark, required this.name});

  final bool isDark;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.public, size: 14, color: AppColors.slate500),
        const SizedBox(width: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.slate500),
      ],
    );
  }
}
