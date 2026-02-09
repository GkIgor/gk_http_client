import 'package:flutter/material.dart';
import 'package:gk_http_client/providers/workspace_provider.dart';
import 'package:provider/provider.dart';
import 'package:gk_http_client/models/collection_model.dart';
import 'package:gk_http_client/providers/request_provider.dart';
import 'package:gk_http_client/theme/app_colors.dart';
import 'package:gk_http_client/widgets/collection_folder.dart';
import 'package:gk_http_client/widgets/custom_scrollbar.dart';
import 'package:gk_http_client/widgets/request_list_item.dart';

class RequestSidebar extends StatefulWidget {
  const RequestSidebar({super.key});

  @override
  State<RequestSidebar> createState() => _RequestSidebarState();
}

class _RequestSidebarState extends State<RequestSidebar> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final WorkspaceProvider wsProvider = Provider.of<WorkspaceProvider>(
      context,
    );

    final workspaceId = wsProvider.currentWorkspace!.id;

    requestProvider.loadCollections(workspaceId);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      color: isDark ? AppColors.sidebarDark : AppColors.slate50,
      child: Column(
        children: [
          _SearchFilter(
            isDark: isDark,
            controller: _searchController,
            onChanged: (value) {
              requestProvider.setSearchFilter(value);
            },
          ),

          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),

          Expanded(
            child: CustomScrollbar(
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                children: [
                  ...requestProvider.filteredCollections.map((collection) {
                    return _Collection(
                      context: context,
                      provider: requestProvider,
                      collection: collection,
                    );
                  }),

                  if (requestProvider.filteredCollections.isEmpty &&
                      requestProvider.searchFilter.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No matches found',
                          style: TextStyle(
                            color: AppColors.slate400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),

          _NewWorkspaceButton(isDark: isDark),
        ],
      ),
    );
  }
}

class _NewWorkspaceButton extends StatelessWidget {
  const _NewWorkspaceButton({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () {
            _openNewCollectionDialog(context, isDark);
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, size: 16, color: AppColors.slate500),
                const SizedBox(width: 4),
                Text(
                  'New Collection',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openNewCollectionDialog(BuildContext context, bool isDark) {
    final Map<String, IconData> icons = {
      'folder': Icons.folder_rounded,
      'api': Icons.api_rounded,
      'webhook': Icons.webhook_rounded,
      'storage': Icons.storage_rounded,
    };

    final Map<String, Color> colors = {
      '#8b5cf6': AppColors.primary,
      '#10b981': const Color(0xFF10b981),
      '#f59e0b': const Color(0xFFf59e0b),
      '#f43f5e': const Color(0xFFf43f5e),
    };

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: _NewWorkspaceDialogBody(
            icons: icons,
            colors: colors,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _NewWorkspaceDialogBody extends StatefulWidget {
  const _NewWorkspaceDialogBody({
    required this.icons,
    required this.colors,
    required this.isDark,
  });

  final Map<String, IconData> icons;
  final Map<String, Color> colors;
  final bool isDark;

  @override
  State<_NewWorkspaceDialogBody> createState() =>
      _NewWorkspaceDialogBodyState();
}

class _NewWorkspaceDialogBodyState extends State<_NewWorkspaceDialogBody> {
  Color currentColor = AppColors.primary;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 500,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.create_new_folder),
                const SizedBox(width: 8),
                const Text('Create New Collection'),
              ],
            ),
            Divider(
              height: 1,
              color: widget.isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
            ),
            const SizedBox(height: 25),
            const Text('COLLECTION NAME'),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g. Payments API',
                hintStyle: TextStyle(
                  color: widget.isDark
                      ? AppColors.textDark
                      : AppColors.textLight,
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SELECT ICON'),
                    // const SizedBox(height: 2),
                    Row(
                      children: [
                        for (final entry in widget.icons.entries) ...[
                          _buildIconSelector(entry),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Column(
                  children: [
                    Text('FOLDER COLOR'),
                    Row(
                      children: [
                        for (final color in widget.colors.entries) ...[
                          _buildColorSelector(
                            color,
                            color.value == currentColor,
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DESCRIPTION (OPTIONAL)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 8,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText:
                        'Briefly describe the purpose of this collection...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector(MapEntry<String, IconData> entry) {
    return InkWell(
      onTap: () {
        debugPrint('Selected icon: ${entry.key}');
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderDark),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(entry.value),
      ),
    );
  }

  Widget _buildColorSelector(MapEntry<String, Color> entry, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          currentColor = entry.value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? entry.value : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(color: entry.value, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    required this.context,
    required this.provider,
    required this.collection,
  });

  final BuildContext context;
  final RequestProvider provider;
  final RequestCollection collection;

  @override
  Widget build(BuildContext context) {
    return CollectionFolder(
      collection: collection,
      isExpanded: collection.isExpanded,
      onToggle: () {
        provider.toggleCollectionExpansion(collection.id);
      },
      onMoreOptions: () {
        // TODO: Collection options
      },
      child: Column(
        children: collection.requests.map((request) {
          final isSelected = provider.selectedRequest?.id == request.id;

          return RequestListItem(
            request: request,
            isSelected: isSelected,
            onTap: () {
              provider.selectRequest(request);
            },
            onMoreOptions: () {
              // TODO: Request options
            },
          );
        }).toList(),
      ),
    );
  }
}

class _SearchFilter extends StatelessWidget {
  const _SearchFilter({
    required this.isDark,
    required this.controller,
    required this.onChanged,
  });

  final bool isDark;
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(Icons.search_rounded, size: 16, color: AppColors.slate400),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Filter requests...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.slate400),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 12),
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
