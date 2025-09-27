import 'dart:convert';
import 'package:client/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config.dart';

class ListService {
  static Future<Map<String, dynamic>> createList(Map<String, dynamic> formData) async {
    try {
      final token = await TokenStorage.getToken();
      String? userId;
      if (token != null && token.isNotEmpty) {
        final decodedToken = JwtDecoder.decode(token);
        userId = decodedToken['id'];
      }

      final url = Uri.parse('$apiUrl/lists/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'listName': formData['listName'],
          'description': formData['description'],
          'listColor': formData['listColor'] ?? '#FFFFFF', 
          'category': formData['category'], // Asegúrate de que categoryList esté definido
          'owner': [userId], // Asegúrate de que userId esté definido
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Lista creada exitosamente'};
      } else {
        return {'success': false, 'message': 'Error al crear la lista'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(), // Detalle técnico del error
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getListsByCategory(String category) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/category/$category');
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

  static Future<void> deleteList(String listId) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('Lista eliminada exitosamente');
      } else {
        print('Error al eliminar la lista');
      }
    } catch (e) {
      print('No se pudo conectar al servidor. Inténtalo de nuevo.');
    }
  }

  static Future<Map<String, dynamic>> updateList(String listId, Map<String, dynamic> formData) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'listName': formData['listName'],
          'description': formData['description'],
          'listColor': formData['listColor'] ?? '#FFFFFF', 
          'category': formData['category'], // Asegúrate de que categoryList esté definido
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Lista actualizada exitosamente'};
      } else {
        return {'success': false, 'message': 'Error al actualizar la lista'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(), // Detalle técnico del error
      };
    }
  }

  static Future<Map<String, dynamic>> getListById(String listId) async {
    try {
      final token = await TokenStorage.getToken();
      final url = Uri.parse('$apiUrl/lists/$listId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Error al obtener la lista'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Inténtalo de nuevo.',
        'error': e.toString(), // Detalle técnico del error
      };
    }
  }
}