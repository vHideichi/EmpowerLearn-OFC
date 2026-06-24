import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/course_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nome = 'Usuário';
  String inicial = 'U';

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();
    final n = prefs.getString('userNome') ?? 'Usuário';
    setState(() {
      nome = n;
      inicial = n.isNotEmpty ? n[0].toUpperCase() : 'U';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF13203F), Color(0xFF1B1042)],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5B5FFF), Color(0xFFB245FF)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              inicial,
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Olá, $nome! 👋",
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Continue aprendendo",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        StatCard(icon: Icons.menu_book, value: "6", label: "Cursos", color: AppColors.blue),
                        StatCard(icon: Icons.check_circle, value: "42", label: "Concluídas", color: AppColors.green),
                        StatCard(icon: Icons.trending_up, value: "14d", label: "Sequência", color: AppColors.purple),
                        StatCard(icon: Icons.workspace_premium, value: "92%", label: "Média", color: AppColors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Continuar Aprendendo", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("Ver todos", style: TextStyle(color: Colors.blue, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CourseCard(title: "React Avançado", subtitle: "Próximo: Context API", progress: 0.75, color: AppColors.blue),
                    const CourseCard(title: "Fundamentos de IA", subtitle: "Próximo: Neural Networks", progress: 0.60, color: AppColors.purple),
                    const CourseCard(title: "Design Thinking", subtitle: "Próximo: User Research", progress: 0.85, color: AppColors.green),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Próximas Tarefas", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("Ver todas", style: TextStyle(color: Colors.blue, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TaskCard(task: TaskModel(title: "Projeto Final de Desenvolvimento Web", course: "React Avançado", date: "2 dias", points: 100, attachments: 2, color: Colors.cyan, status: "A Fazer")),
                    const SizedBox(height: 14),
                    TaskCard(task: TaskModel(title: "Implementação de Rede Neural", course: "Fundamentos de IA", date: "4 dias", points: 150, attachments: 1, color: Colors.pink, status: "Fazendo")),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [Color(0xFF1F2A63), Color(0xFF241A52)]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sequência de Estudos", style: TextStyle(color: Colors.white70, fontSize: 13)),
                              SizedBox(height: 6),
                              Text("14 dias 🔥", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(colors: [Color(0xFF4F7BFF), Color(0xFF7B4DFF)]),
                            ),
                            child: const Icon(Icons.trending_up, color: Colors.white, size: 30),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}