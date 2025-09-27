import 'package:client/services/task_service.dart';
import 'package:client/widgets/delete_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/create_task_form.dart';
import 'package:client/widgets/update_task_form.dart';

class TaskListScreen extends StatefulWidget {
  final String listId;
  final String listName;
  final Color listColor;
  final String listDescription;

  const TaskListScreen({
    super.key,
    required this.listId,
    required this.listName,
    required this.listColor,
    required this.listDescription,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await TaskService.getTasksByListId(widget.listId);
    setState(() {
      this.tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((t) => t['completed'] != true).toList();
    final completedTasks = tasks.where((t) => t['completed'] == true).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.listName)),
      backgroundColor: widget.listColor.withOpacity(1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.listDescription,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            CreateTaskButton(
              listId: widget.listId,
              onTaskCreated: _fetchTasks,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No hay tareas'))
                  : ListView(
                      children: [
                        ...incompleteTasks.map(_buildTaskCard).toList(),

                        if (completedTasks.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(thickness: 1),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 8),
                            child: Text(
                              'Completadas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...completedTasks.map(_buildTaskCard).toList(),
                        ],
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  task['favorite'] == true ? Icons.favorite : Icons.favorite_border,
                  color: task['favorite'] == true ? Colors.red : Colors.grey,
                ),
                onPressed: () async {
                  await TaskService.toggleFavorite(task['_id'], widget.listId, !task['favorite']);
                  _fetchTasks();
                },
              ),
              IconButton(
                onPressed: () async {
                  await TaskService.toggleCompleted(task['_id'], widget.listId, !task['completed']);
                  _fetchTasks();
                },
                icon: Icon(
                  task['completed'] == true ? Icons.check_circle : Icons.circle,
                  color: task['completed'] == true ? Colors.blue : Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  task['description'] ?? 'Sin descripción',
                  style: const TextStyle(fontSize: 16),
                ),
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Text(
                    task['priority'] ?? 'Sin prioridad',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    task['repeat'] ?? 'Sin repetición',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  ],
                ),
                ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteListDialog(
                      taskId: task['_id'],
                      taskListId: widget.listId,
                      onDeleted: _fetchTasks,
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
              UpdateTaskButton(
                listId: widget.listId,
                taskData: task,
                onTaskUpdated: _fetchTasks,
              )
            ],
          ),
        ),
      ),
    );
  }
}
