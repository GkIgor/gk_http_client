import 'package:flutter/material.dart';
import 'package:gk_http_client/services/navigation_service.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF252526),
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
                    name,
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
                  icon: const Icon(Icons.add, size: 18, color: Colors.white70),
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
        ],
      ),
    );
  }
}
