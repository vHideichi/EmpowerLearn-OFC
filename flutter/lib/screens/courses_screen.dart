import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';
import 'materias_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<dynamic> _cursos = [];
  bool _carregando = true;
  String _userTipo = 'aluno';
  String? _erro;

  bool get _isProfessorOuAdmin {
    return _userTipo == 'professor' || _userTipo == 'admin';
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final tipo = prefs.getString('userTipo') ?? 'aluno';
      final cursos = await ApiService.getCursos();

      if (!mounted) return;

      setState(() {
        _userTipo = tipo;
        _cursos = cursos;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar cursos.';
        _cursos = [];
        _carregando = false;
      });
    }
  }

  void _abrirMaterias(Map<String, dynamic> curso) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MateriasScreen(curso: curso),
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String hint, {
    int linhas = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
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

  void _abrirCriarCurso() {
    final tituloCtrl = TextEditingController();
    final descricaoCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color(0xFF081225),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Criar Novo Curso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _campo(tituloCtrl, 'Título do curso'),
              const SizedBox(height: 12),
              _campo(
                descricaoCtrl,
                'Descrição do curso',
                linhas: 3,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final titulo = tituloCtrl.text.trim();
                    final descricao = descricaoCtrl.text.trim();

                    if (titulo.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe o título do curso.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(sheetContext);

                    try {
                      await ApiService.createCurso({
                        'titulo': titulo,
                        'descricao': descricao,
                      });

                      await _carregar();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Curso criado!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao criar curso: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Criar Curso',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      tituloCtrl.dispose();
      descricaoCtrl.dispose();
    });
  }

  void _abrirEditarCurso(Map<String, dynamic> curso) {
    final tituloCtrl = TextEditingController(
      text: curso['titulo']?.toString() ?? '',
    );

    final descricaoCtrl = TextEditingController(
      text: curso['descricao']?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color(0xFF081225),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Editar Curso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _campo(tituloCtrl, 'Título do curso'),
              const SizedBox(height: 12),
              _campo(
                descricaoCtrl,
                'Descrição do curso',
                linhas: 3,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final titulo = tituloCtrl.text.trim();
                    final descricao = descricaoCtrl.text.trim();

                    if (titulo.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe o título do curso.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(sheetContext);

                    try {
                      await ApiService.updateCurso(curso['id'], {
                        'titulo': titulo,
                        'descricao': descricao,
                      });

                      await _carregar();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Curso atualizado!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao atualizar curso: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      tituloCtrl.dispose();
      descricaoCtrl.dispose();
    });
  }

  Future<void> _matricular(int cursoId) async {
    try {
      await ApiService.matricular(cursoId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matriculado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao matricular: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletarCurso(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111C3D),
          title: const Text(
            'Confirmar',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Deseja deletar este curso?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await ApiService.deleteCurso(id);
      await _carregar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Curso removido.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar curso: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _cardCurso(Map<String, dynamic> curso) {
    final titulo = curso['titulo']?.toString() ?? 'Sem título';
    final descricao = curso['descricao']?.toString() ?? '';
    final publicado = curso['publicado'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _abrirMaterias(curso),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4A6CFF),
                    Color(0xFF7B3FFF),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (publicado)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Publicado',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirMaterias(curso),
                      icon: const Icon(
                        Icons.menu_book_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Ver matérias',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_userTipo == 'aluno')
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _matricular(curso['id']),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF4A6CFF),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Matricular-se',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (_isProfessorOuAdmin)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _abrirEditarCurso(curso),
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF4A6CFF),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        if (_userTipo == 'admin') ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _deletarCurso(curso['id']),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 140),
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _erro!,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: _cursos.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 160),
                const Icon(
                  Icons.school_outlined,
                  color: Colors.white30,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Nenhum curso disponível',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                if (_isProfessorOuAdmin) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _abrirCriarCurso,
                      icon: const Icon(Icons.add),
                      label: const Text('Criar primeiro curso'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6CFF),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cursos.length,
              itemBuilder: (_, index) {
                final curso = Map<String, dynamic>.from(_cursos[index] as Map);
                return _cardCurso(curso);
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cursos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isProfessorOuAdmin)
            IconButton(
              onPressed: _abrirCriarCurso,
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Criar Curso',
            ),
        ],
      ),
      body: _body(),
    );
  }
}