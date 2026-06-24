import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedFilter = 0;
  String _userTipo = '';
  bool _carregando = true;
  List<dynamic> _tarefas = [];

  final List<Color> _cores = [Colors.cyan, Colors.pink, Colors.green, Colors.orange, Colors.purple];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final tipo = prefs.getString('userTipo') ?? 'aluno';

    setState(() {
      _userTipo = tipo;
      _carregando = false;
    });
  }

  bool get _isProfessor => _userTipo == 'professor' || _userTipo == 'admin';

  List<String> get _filtros => ['Todas', 'A Fazer', 'Fazendo', 'Enviados'];

  List<dynamic> get _tarefasFiltradas {
    if (_selectedFilter == 0) return _tarefas;
    final status = _filtros[_selectedFilter];
    return _tarefas.where((t) => t['status'] == status).toList();
  }

  void _abrirCriarTarefa() {
    final tituloCtrl = TextEditingController();
    final descricaoCtrl = TextEditingController();
    final materiaIdCtrl = TextEditingController();
    DateTime? prazo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF081225),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 60, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)))),
              const SizedBox(height: 24),
              const Text("Criar Nova Tarefa", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _campo(tituloCtrl, "Título da tarefa"),
              const SizedBox(height: 12),
              _campo(descricaoCtrl, "Descrição", linhas: 3),
              const SizedBox(height: 12),
              _campo(materiaIdCtrl, "ID da Matéria"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setModalState(() => prazo = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF111C3D), borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        prazo != null ? '${prazo!.day}/${prazo!.month}/${prazo!.year}' : 'Selecionar prazo',
                        style: TextStyle(color: prazo != null ? Colors.white : Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (tituloCtrl.text.trim().isEmpty || materiaIdCtrl.text.trim().isEmpty || prazo == null) return;
                    Navigator.pop(context);
                    await ApiService.createTarefa({
                      'titulo': tituloCtrl.text.trim(),
                      'descricao': descricaoCtrl.text.trim(),
                      'materiaId': int.tryParse(materiaIdCtrl.text.trim()) ?? 0,
                      'prazo': prazo!.toIso8601String(),
                    });
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarefa criada!'), backgroundColor: Colors.green),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Criar Tarefa", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirSubmeter(dynamic tarefa) {
    final respostaCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF081225),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 60, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)))),
            const SizedBox(height: 24),
            Text(tarefa['titulo'] ?? 'Tarefa', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(tarefa['descricao'] ?? '', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 20),
            _campo(respostaCtrl, "Sua resposta...", linhas: 5),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (respostaCtrl.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  await ApiService.submeterTarefa(tarefa['id'], respostaCtrl.text.trim());
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tarefa enviada!'), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6CFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Enviar Resposta", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String hint, {int linhas = 1}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF111C3D), borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: ctrl,
        maxLines: linhas,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      floatingActionButton: _isProfessor
          ? FloatingActionButton.extended(
              onPressed: _abrirCriarTarefa,
              backgroundColor: const Color(0xFF4A6CFF),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Criar Tarefa", style: TextStyle(color: Colors.white)),
            )
          : null,
      body: SafeArea(
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        const Text("Atividades", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 30),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _statCard("Tarefas", _tarefas.length.toString())),
                        const SizedBox(width: 12),
                        Expanded(child: _statCard("Tipo", _isProfessor ? 'Professor' : 'Aluno', valueColor: const Color(0xFF4A6CFF))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filtros.length,
                        itemBuilder: (_, index) {
                          final selected = _selectedFilter == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedFilter = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFF6C63FF) : const Color(0xFF111C3D),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(_filtros[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _tarefas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.assignment_outlined, color: Colors.white30, size: 64),
                                  const SizedBox(height: 16),
                                  Text(
                                    _isProfessor ? 'Nenhuma tarefa criada.\nClique em + para criar.' : 'Nenhuma tarefa disponível.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _tarefasFiltradas.length,
                              itemBuilder: (_, index) {
                                final tarefa = _tarefasFiltradas[index];
                                final cor = _cores[index % _cores.length];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF111C3D),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border(left: BorderSide(color: cor, width: 4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tarefa['titulo'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(tarefa['descricao'] ?? '', style: const TextStyle(color: Colors.white60, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_today, color: Colors.white38, size: 14),
                                                const SizedBox(width: 4),
                                                Text(
                                                  tarefa['prazo'] != null
                                                      ? DateTime.parse(tarefa['prazo']).toString().substring(0, 10)
                                                      : 'Sem prazo',
                                                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            if (!_isProfessor)
                                              ElevatedButton(
                                                onPressed: () => _abrirSubmeter(tarefa),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: cor.withOpacity(0.2),
                                                  foregroundColor: cor,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                ),
                                                child: const Text("Submeter", style: TextStyle(fontSize: 13)),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _statCard(String title, String value, {Color valueColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111C3D), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: valueColor, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}