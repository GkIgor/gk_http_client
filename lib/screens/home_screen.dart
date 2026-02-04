import 'package:flutter/material.dart';
import 'package:gk_http_client/models/workspace_models.dart';
import 'package:gk_http_client/repository/workspace_repository.dart';
import 'package:gk_http_client/services/navigation_service.dart';
import 'package:gk_http_client/theme/app_colors.dart';
import 'package:gk_http_client/widgets/icon_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkspaceRepository _repository = WorkspaceRepository();
  final GlobalKey _buttonKey = GlobalKey();
  List<WorkspaceModel> _workspaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkspaces();
  }

  Future<void> _loadWorkspaces() async {
    try {
      final workspaces = await _repository.getAll();
      setState(() {
        _workspaces = workspaces;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // TODO: Show error
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seus Workspaces',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage and organize your API projects',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.slate500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _workspaces.isEmpty
                  ? _buildEmptyState(context)
                  : GridView.builder(
                      padding: const EdgeInsets.all(40),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.5,
                          ),
                      itemCount: _workspaces.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildAddButton(context);
                        }
                        return _buildWorkspaceCard(
                          context,
                          _workspaces[index - 1],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceCard(BuildContext context, WorkspaceModel workspace) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        NavigationService.navigateTo(
          AppRoute.workspace,
          workspaceName: workspace.name,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    key: _buttonKey,
                    onTap: () {
                      // Button Position
                      final RenderBox button =
                          _buttonKey.currentContext!.findRenderObject()
                              as RenderBox;

                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;

                      // Position Relative
                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay,
                          ),
                        ),
                        Offset.zero & overlay.size,
                      );

                      _openIconSelector(context, position);
                    },
                    child: const Icon(
                      Icons.folder_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_horiz, color: AppColors.slate400),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    // TODO: Implement delete
                  },
                ),
              ],
            ),
            const Spacer(),
            Text(
              workspace.name,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${workspace.environments.length} environments',
              style: TextStyle(color: AppColors.slate500, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showCreateWorkspaceDialog(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.slate300,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ), // Dashed border replacement
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 32,
                color: AppColors.slate400,
              ),
              const SizedBox(height: 12),
              Text(
                'New Workspace',
                style: TextStyle(
                  color: AppColors.slate500,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.slate300),
          const SizedBox(height: 16),
          Text(
            'No workspaces found',
            style: TextStyle(color: AppColors.slate500, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateWorkspaceDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create First Workspace'),
          ),
        ],
      ),
    );
  }

  void _showCreateWorkspaceDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Workspace Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final ws = WorkspaceModel(name: controller.text);
                await _repository.save(ws);
                if (context.mounted) {
                  Navigator.pop(context);
                  _loadWorkspaces();
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _openIconSelector(BuildContext context, RelativeRect position) {
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          enabled: false,
          value: 'icon_selector',
          child: SizedBox(width: 250, height: 150, child: const IconSelector()),
        ),
      ],
    );
  }
}
