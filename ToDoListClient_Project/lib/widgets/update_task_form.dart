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

class UpdateTaskButton extends StatelessWidget{
  final String listId;
  final Map<String, dynamic>? taskData; // Datos de la tarea a actualizar
  final VoidCallback? onTaskUpdated;

  const UpdateTaskButton({
    super.key, 
    required this.listId,
    this.taskData,
    this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showUpdateTaskDialog(context),
      icon: const Icon(Icons.edit, color: Colors.blue),
    );
  }

  void _showUpdateTaskDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController(
      text: taskData?['description'] ?? '',
    );
    String selectedRepeatKey = taskData?['repeat']; // por defecto
    String selectedPriorityKey = taskData?['priority']; // por defecto
    bool isFavorite = taskData?['favorite']; // valor por defecto

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
                          final formdata = {
                            'description': _descriptionController.text.trim(),
                            'repeat': selectedRepeatKey,
                            'priority': selectedPriorityKey,
                            'favorite': isFavorite,
                          };
                          await TaskService.updateTask(
                            taskData?['_id'],
                            listId,
                            formdata,
                          );
                          Navigator.of(context).pop();
                          if (onTaskUpdated != null) {
                            onTaskUpdated!(); // Notifica al padre
                          }
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

