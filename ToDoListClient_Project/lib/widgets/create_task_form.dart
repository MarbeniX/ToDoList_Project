import 'package:client/services/task_service.dart';
import 'package:flutter/material.dart';

const Map<String, String> repeatOptions = {
  'daily': 'daily',
  'weekly': 'weekly',
  'monthly': 'monthly',
  'yearly': 'yearly',
};

const Map<String, String> priorityOptions = {
  'blocker': 'blocker',
  'critical': 'critical',
  'high': 'high',
  'normal': 'normal',
  'low': 'low',
  'optional': 'optional',
};

class CreateTaskButton extends StatelessWidget{
  final String listId; 
  final VoidCallback? onTaskCreated;

  const CreateTaskButton({
    super.key, 
    required this.listId,
    this.onTaskCreated,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showCreateTaskDialog(context),
      child: const Text('Crear una tarea'),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController();
    String selectedRepeatKey = repeatOptions.keys.first; // por defecto
    String selectedPriorityKey = priorityOptions.keys.first; // por defecto
    bool isFavorite = false;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo requerido';
                          }else if (value.trim().length > 100) {
                            return 'Máximo 100 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.blue),
                      tooltip: 'Confirmar creación',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final description = _descriptionController.text.trim();
                          final formData = {
                            'description': description,
                            'repeat': selectedRepeatKey,
                            'priority': selectedPriorityKey,
                            'favorite': isFavorite,
                          };
                          final response = await TaskService.createTask(formData, listId);
                          if (response['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tarea creada exitosamente')),
                            );
                            onTaskCreated?.call(); // Llama al callback si se proporcionó
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${response['message']}')),
                            );
                          }
                          Navigator.pop(context); // Cierra el diálogo, si aplica
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedRepeatKey,
                        decoration: const InputDecoration(labelText: 'Repetir'),
                        items: repeatOptions.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedRepeatKey = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedPriorityKey,
                        decoration: const InputDecoration(labelText: 'Prioridad'),
                        items: priorityOptions.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedPriorityKey = value);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
      );
    });
  }
}
