import 'dart:convert';
import 'package:client/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class TaskService {
  static Future<Map<String, dynamic>> createTask(Map<String, dynamic> formData, String listId) async {
    try {
      final token = await TokenStorage.getToken();

      final url = Uri.parse('$apiUrl/lists/$listId/tasks');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'favorite': formData['favorite'] ?? false,
          'description': formData['description'],
          'priority': formData['priority'],
          'repeat': formData['repeat'],
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Tarea creada exitosamente'};
      } else {
        return {'success': false, 'message': 'Error al crear la tarea'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getTasksByListId(String listId) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId/getTasks');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> toggleFavorite(String taskId, String listId, bool isFavorite) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId/tasks/$taskId/favorite');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'favorite': isFavorite}),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Estado de favorito actualizado'};
      } else {
        return {'success': false, 'message': 'Error al actualizar el estado de favorito'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> toggleCompleted(String taskId, String listId, bool isCompleted) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId/tasks/$taskId/completed');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'completed': isCompleted}),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Estado de completado actualizado'};
      } else {
        return {'success': false, 'message': 'Error al actualizar el estado de completado'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(),
      };
    }
  }

  static Future<String> deleteTask(String taskId, String listId) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId/tasks/$taskId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return 'Tarea eliminada exitosamente';
      } else {
        return 'Error al eliminar la tarea';
      }
    } catch (e) {
      return 'No se pudo conectar al servidor. Inténtalo de nuevo.';
    }
  }

  static Future<Map<String, dynamic>> updateTask(
    String taskId,
    String listId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId/tasks/$taskId');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Tarea actualizada exitosamente'};
      } else {
        return {'success': false, 'message': 'Error al actualizar la tarea'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(),
      };
    }
  }
}