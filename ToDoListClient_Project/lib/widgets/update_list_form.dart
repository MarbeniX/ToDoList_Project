import 'package:flutter/material.dart';
import 'package:client/services/list_service.dart';

const Map<String, String> colorList = {
  'RED': '#FF0000',
  'ORANGE': '#FFA500',
  'YELLOW': '#FFFF00',
  'GREEN': '#008000',
  'BLUE': '#0000FF',
  'PURPLE': '#800080',
  'PINK': '#FFC0CB',
  'BROWN': '#A52A2A',
  'GRAY': '#808080',
};

const Map<String, String> categoryList = {
  'PERSONAL': 'personal',
  'WORK': 'work',
  'URGENT': 'urgent',
};

class EditListButton extends StatelessWidget {
  final Map<String, dynamic> list;
  final VoidCallback? onListUpdated;

  const EditListButton({
    super.key,
    required this.list,
    this.onListUpdated,
  });

  static int _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => _showEditListDialog(context),
    );
  }

  void _showEditListDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: list['listName']);
    final _descriptionController = TextEditingController(text: list['description']);

    // Buscar claves desde los valores
    String selectedColorKey = colorList.entries
        .firstWhere((e) => e.value == list['listColor'], orElse: () => const MapEntry('GRAY', '#808080'))
        .key;

    String selectedCategoryKey = categoryList.entries
        .firstWhere((e) => e.value == list['category'], orElse: () => const MapEntry('PERSONAL', 'personal'))
        .key;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Lista'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'El nombre es requerido';
                  if (value.trim().length > 20) return 'Máximo 20 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'La descripción es requerida';
                  if (value.trim().length > 100) return 'Máximo 100 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedColorKey,
                decoration: const InputDecoration(labelText: 'Color'),
                items: colorList.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Color(_hexToColor(entry.value)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedColorKey = value;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategoryKey,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: categoryList.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedCategoryKey = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final formData = {
                  'listName': _nameController.text.trim(),
                  'description': _descriptionController.text.trim(),
                  'listColor': colorList[selectedColorKey],
                  'category': categoryList[selectedCategoryKey],
                };

                final response = await ListService.updateList(list['_id'], formData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response['message'] ?? 'Actualización completada')),
                );

                if (response['success']) {
                  Navigator.pop(context);
                  if (onListUpdated != null) onListUpdated!();
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
