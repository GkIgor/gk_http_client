import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gk_http_client/providers/request_provider.dart';
import 'package:gk_http_client/providers/theme_provider.dart';
import 'package:gk_http_client/services/navigation_service.dart';
import 'package:gk_http_client/theme/app_colors.dart';
import 'package:gk_http_client/views/request_sidebar.dart';
import 'package:gk_http_client/widgets/empty_request_editor.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header / App Bar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: [
                // Logo & Workspace Name
                InkWell(
                  onTap: () => NavigationService.goBack(),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            'GK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HTTP Client',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(width: 32, indent: 12, endIndent: 12),

                // Environment Selector (Placeholder)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.slate800 : AppColors.slate100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.public, size: 14, color: AppColors.slate500),
                      const SizedBox(width: 8),
                      Text(
                        'Production Env',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: AppColors.slate500,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Theme Toggle
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    size: 20,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip: 'Toggle Theme',
                ),

                const SizedBox(width: 8),

                // User Avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.slate300,
                  child: Text(
                    'U',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // Sidebar
                const RequestSidebar(),

                // Vertical Divider
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),

                // Request Editor / Response Area
                Expanded(
                  child: requestProvider.selectedRequest != null
                      ? Center(
                          child: Text('Request Editor Placeholder'),
                        ) // TODO: Implement RequestEditor
                      : const EmptyRequestEditor(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
