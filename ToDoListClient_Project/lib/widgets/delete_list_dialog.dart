import 'package:client/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:client/services/list_service.dart';

class DeleteListDialog extends StatelessWidget {
  final String? listId;
  final String? taskId;
  final String? taskListId;
  final VoidCallback? onDeleted;

  const DeleteListDialog({
    super.key,
    this.listId,
    this.onDeleted,
    this.taskId,
    this.taskListId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${listId != null ? 'Eliminar lista' : 'Eliminar tarea'}'),
      content: Text('¿Estás seguro de que deseas eliminar esta ${listId != null ? 'lista' : 'tarea'}? Esta acción no se puede deshacer.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancelar
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            if (listId != null) {
              await ListService.deleteList(listId!);
              Navigator.of(context).pop(); // Cierra el dialog
              if (onDeleted != null) onDeleted!(); // Notifica al padre
            } else if (taskId != null) {
              await TaskService.deleteTask(taskId!, taskListId!);
              Navigator.of(context).pop(); // Cierra el dialog
              if (onDeleted != null) onDeleted!(); // Notifica al padre
            }
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
