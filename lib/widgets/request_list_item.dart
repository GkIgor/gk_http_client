import 'package:flutter/material.dart';
import 'package:gk_http_client/models/http_request.dart';
import 'package:gk_http_client/theme/app_colors.dart';
import 'package:gk_http_client/widgets/method_badge.dart';

class RequestListItem extends StatelessWidget {
  final HttpRequest request;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onMoreOptions;

  const RequestListItem({
    super.key,
    required this.request,
    required this.isSelected,
    required this.onTap,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.slate800 : AppColors.slate200)
              : null,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border(left: BorderSide(color: AppColors.primary, width: 3))
              : const Border(
                  left: BorderSide(color: Colors.transparent, width: 3),
                ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: MethodBadge(method: request.method, small: true),
            ),
            Expanded(
              child: Text(
                request.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? AppColors.textDark : AppColors.textLight)
                      : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
