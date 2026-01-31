import 'package:flutter/material.dart';
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
    final provider = Provider.of<RequestProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      color: isDark ? AppColors.sidebarDark : AppColors.slate50,
      child: Column(
        children: [
          // Search Header
          Padding(
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
                  Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Filter requests...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.slate400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(bottom: 12),
                      ),
                      onChanged: (value) {
                        provider.setSearchFilter(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),

          // Lists
          Expanded(
            child: CustomScrollbar(
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                children: [
                  ...provider.filteredCollections.map((collection) {
                    return _buildCollection(context, provider, collection);
                  }),

                  if (provider.filteredCollections.isEmpty &&
                      provider.searchFilter.isNotEmpty)
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

          // New Collection Button
          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {
                final newCollection = RequestCollection(
                  name: 'New Collection',
                  requests: [],
                );
                provider.addCollection(newCollection);
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppColors.slate500,
                    ),
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
        ],
      ),
    );
  }

  Widget _buildCollection(
    BuildContext context,
    RequestProvider provider,
    RequestCollection collection,
  ) {
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
