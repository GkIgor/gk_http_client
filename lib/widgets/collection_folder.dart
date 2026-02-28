import 'package:flutter/material.dart';
import 'package:gk_http_client/models/collection_model.dart';
import 'package:gk_http_client/models/http_method.dart';
import 'package:gk_http_client/models/http_request.dart';
import 'package:gk_http_client/providers/request_provider.dart';
import 'package:gk_http_client/theme/app_colors.dart';
import 'package:gk_http_client/widgets/dialogs/manage_collection.dart';
import 'package:provider/provider.dart';

class CollectionFolder extends StatelessWidget {
  final RequestCollection collection;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child; // Lista de requisições

  const CollectionFolder({
    super.key,
    required this.collection,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final collectionProvider = Provider.of<RequestProvider>(context);

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
                Opacity(
                  opacity: 0.7, // TODO: Hover effect to show/hide
                  child: PopupMenuButton(
                    itemBuilder: (_) =>
                        _popupMenuItems(collectionProvider, context),
                    icon: const Icon(
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

  List<PopupMenuItem<void>> _popupMenuItems(
    RequestProvider provider,
    BuildContext context,
  ) {
    return [
      PopupMenuItem(
        onTap: () async {
          await _createNewRequest(context, provider);
        },
        child: const Text('Create New Request'),
      ),
      PopupMenuItem(
        onTap: () {
          _openEditCollectionDialog(
            context,
            Theme.of(context).brightness == Brightness.dark,
          );
        },
        child: const Text('Edit'),
      ),
      PopupMenuItem(
        onTap: () async {
          await provider.removeCollection(collection.id);
        },
        child: const Text('Delete'),
      ),
    ];
  }

  void _openEditCollectionDialog(BuildContext context, bool isDark) {
    final Map<String, IconData> icons = RequestProvider.icons;
    final Map<String, Color> colors = RequestProvider.colors;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: NewCollectionDialogBody(
            icons: icons,
            colors: colors,
            isDark: isDark,
            collection: collection,
          ),
        );
      },
    );
  }

  Future<void> _createNewRequest(
    BuildContext context,
    RequestProvider provider,
  ) async {
    final newRequest = HttpRequest(
      id: UniqueKey().toString(),
      name: 'New Request',
      method: HttpMethod.get,
      url: '',
    );

    final updatedCollection = collection.copyWith(
      requests: [...collection.requests, newRequest],
    );

    await provider.updateCollection(updatedCollection);
  }
}
