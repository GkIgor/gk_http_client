import 'package:flutter/material.dart';
import 'package:gk_http_client/models/collection_model.dart';
import 'package:gk_http_client/theme/app_colors.dart';

class CollectionFolder extends StatelessWidget {
  final RequestCollection collection;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child; // Lista de requisições
  final VoidCallback? onMoreOptions;

  const CollectionFolder({
    super.key,
    required this.collection,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded,
                  size: 16,
                  color: AppColors.slate400,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    collection.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ),
                if (onMoreOptions != null)
                  Opacity(
                    opacity: 0.7, // TODO: Hover effect to show/hide
                    child: InkWell(
                      onTap: onMoreOptions,
                      child: const Icon(
                        Icons.more_horiz_rounded,
                        size: 16,
                        color: AppColors.slate400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: child, // Container para os RequestListItems
          ),
      ],
    );
  }
}
