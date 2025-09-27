import 'package:client/services/auth_service.dart';
import 'package:flutter/material.dart';

class ValidateTokenScreen extends StatefulWidget {
  const ValidateTokenScreen({Key? key}) : super(key: key);

  @override
  State<ValidateTokenScreen> createState() => _ValidateTokenScreenState();
}

class _ValidateTokenScreenState extends State<ValidateTokenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _handleValidateToken() async {
    if (_formKey.currentState!.validate()) {
      final token = _tokenController.text.trim();

      final response = await AuthService.validateToken(token);
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pushReplacementNamed(
          context,
          '/reset-password',
          arguments: token,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar Token')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingresa el código de 6 dígitos que te enviamos para recuperar tu contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _tokenController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Código de recuperación',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length != 6) {
                      return 'Ingresa un código válido de 6 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleValidateToken,
                  child: const Text('Validar código'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
