import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';
import 'screens/courses_screen.dart';
import 'screens/forum_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _verificarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmpowerLearn.class',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF081225),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6CFF),
          brightness: Brightness.dark,
        ),
      ),
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomeScreen(),
        '/courses': (_) => const CoursesScreen(),
        '/tasks': (_) => const TasksScreen(),
        '/forum': (_) => const ForumScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
      home: FutureBuilder<bool>(
        future: _verificarSessao(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF081225),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A6CFF),
                ),
              ),
            );
          }

          final logado = snapshot.data ?? false;

          if (logado) {
            return const HomeScreen();
          }

          return const LoginPage();
        },
      ),
    );
  }
}