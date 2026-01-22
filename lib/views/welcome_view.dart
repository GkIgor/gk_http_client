import 'package:flutter/material.dart';
import 'package:gk_http_client/services/navigation_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final List<String> _workspaces = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seus Workspaces',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _WorkspaceCard(
                  isAddCard: true,
                  onTap: () => _showCreateWorkspaceDialog(context),
                ),
                ..._workspaces.map(
                  (name) => _WorkspaceCard(
                    isAddCard: false,
                    title: name,
                    onTap: () => _openWorkspace(name),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateWorkspaceDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _alertDialog(context));
  }

  AlertDialog _alertDialog(BuildContext context) {
    final TextEditingController workspaceName = TextEditingController();
    String? errorText;

    return AlertDialog(
      backgroundColor: const Color(0xFF2B2B2B),
      title: const Text(
        'Novo Workspace',
        style: TextStyle(color: Colors.white),
      ),
      content: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            mainAxisSize: .min,
            children: [
              TextField(
                controller: workspaceName,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome do Projeto',
                  errorText: errorText,
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: .end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      workspaceName.dispose();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var (ok, error) = _createNewWorkspace(workspaceName);

                      if (error != null) {
                        setModalState(() {
                          errorText = error.toString().replaceFirst(
                            'Exception: ',
                            '',
                          );
                        });
                        return;
                      }

                      Navigator.pop(context);
                      workspaceName.dispose();
                    },
                    child: const Text('Criar'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  (bool?, Exception?) _createNewWorkspace(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return (null, Exception('Nome do workspace é obrigatório'));
    }

    if (mounted) {
      setState(() {
        _workspaces.add(controller.text);
      });
    }

    return (true, null);
  }

  void _openWorkspace(String name) {
    NavigationService.navigateTo(.workspace, workspaceName: name);
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required bool isAddCard,
    this.title,
    required this.onTap,
  }) : _isAddCard = isAddCard;

  final bool _isAddCard;
  final String? title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF3C3F41),
      elevation: 0.8,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: _isAddCard
              ? const Icon(Icons.add, size: 40, color: Colors.white54)
              : Text(
                  title ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
        ),
      ),
    );
  }
}
