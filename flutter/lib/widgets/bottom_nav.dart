import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    this.currentIndex = 0,
  });

  static const List<String> _rotas = [
    '/home',
    '/courses',
    '/tasks',
    '/forum',
    '/profile',
  ];

  void _navegar(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index < 0 || index >= _rotas.length) return;

    Navigator.pushReplacementNamed(
      context,
      _rotas[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navegar(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF081225),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: 'Cursos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_outlined),
          activeIcon: Icon(Icons.task_alt),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum_outlined),
          activeIcon: Icon(Icons.forum),
          label: 'Fórum',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}