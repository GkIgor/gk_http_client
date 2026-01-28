import 'package:flutter/material.dart';
import 'package:gk_http_client/models/workspace_models.dart';
import 'package:gk_http_client/services/navigation_service.dart';
import 'package:gk_http_client/widgets/tree_item.dart';

class SidebarView extends StatefulWidget {
  const SidebarView({super.key, required this.name});

  final String name;

  @override
  State<SidebarView> createState() => _SidebarViewState();
}

class _SidebarViewState extends State<SidebarView> {
  final double _minWidth = 150;
  final double _maxWidth = 500.0;
  final Set<String> _expandedFolderIds = {};
  double _width = 250.0;
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    if (!_isOpen) {
      return Container(width: 40, color: Colors.grey[900]);
    }

    return Row(
      children: [
        Container(
          width: _width,
          color: Color(0XFF1E1E1E),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () => NavigationService.goBack(),
                      tooltip: 'Voltar para Workspaces',
                    ),
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10, height: 1),

              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black12,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'REQUISIÇÕES',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        hoverColor: Colors.white.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white70,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhuma Requisição',
                    style: TextStyle(color: Colors.white24, fontSize: 16),
                  ),
                ),
              ),
              Expanded(child: _buildTreeView()),
              // _buildFooter(),
            ],
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _width += details.delta.dx;
              if (_width < _minWidth) _width = _minWidth;
              if (_width > _maxWidth) _width = _maxWidth;
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Container(width: 4, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTreeView() {
    List<WorkspaceItem> items = [];

    return ListView(children: _buildTreeItems(items, 0));
  }

  List<Widget> _buildTreeItems(List<WorkspaceItem> items, int level) {
    List<Widget> widgets = [];

    for (var item in items) {
      widgets.add(
        TreeItemWidget(
          label: item.name,
          level: level,
          isFolder: item.type == WorkspaceItemType.folder,
          isExpanded: _expandedFolderIds.contains(item.id),
          onTap: () {
            if (item.type == WorkspaceItemType.folder) {
              _toggleFolder(item.id);
            } else {
              // TODO - Open Request
            }
          },
        ),
      );

      if (item.type == .folder && _expandedFolderIds.contains(item.id)) {
        widgets.addAll(_buildTreeItems(item.children, level + 1));
      }
    }
    return widgets;
  }

  void _toggleFolder(String id) {
    setState(() {
      if (_expandedFolderIds.contains(id)) {
        _expandedFolderIds.remove(id);
      } else {
        _expandedFolderIds.add(id);
      }
    });
  }
}
