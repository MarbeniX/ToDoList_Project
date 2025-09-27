// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgotPassword_screen.dart';
import 'screens/auth/confirm_account_screen.dart';
import 'screens/auth/validate_token_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/app/home.dart';
import 'screens/app//personal_lists_screen.dart';
import 'screens/app/work_lists_screen.dart';
import 'screens/app/urgent_lists_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/confirm-account': (context) => const ConfirmAccountScreen(),
        '/validate-token': (context) => const ValidateTokenScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/personal': (context) => const PersonalListsScreen(),
        '/work': (context) => const WorkListsScreen(),
        '/urgent': (context) => const UrgentListsScreen(),
        '/task-list': (context) => const Placeholder()
      },
    );
  }
}
