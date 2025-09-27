import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      setState(() {
        userName = decodedToken['username'];
        userEmail = decodedToken['email'];
      });
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleCategoryTap(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        Navigator.pushNamed(context, '/personal');
        break;
      case 'trabajo':
        Navigator.pushNamed(context, '/work');
        break;
      case 'urgente':
        Navigator.pushNamed(context, '/urgent');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría no reconocida: $category')),
        );
    }
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () => _handleCategoryTap(title),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: const TextStyle(fontSize: 18)),
            Text(userEmail, style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCategoryCard('Personal', Icons.person),
            _buildCategoryCard('Trabajo', Icons.work),
            _buildCategoryCard('Urgente', Icons.warning_amber_rounded),
          ],
        ),
      ),
    );
  }
}
