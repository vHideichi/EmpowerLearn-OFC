import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class MateriasScreen extends StatefulWidget {
  final Map<String, dynamic> curso;

  const MateriasScreen({
    super.key,
    required this.curso,
  });

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  List<dynamic> _materias = [];
  bool _carregando = true;
  bool _salvando = false;
  String _userTipo = 'aluno';
  String? _erro;

  int get _cursoId {
    final id = widget.curso['id'];
    if (id is int) return id;
    return int.tryParse(id.toString()) ?? 0;
  }

  String get _cursoTitulo {
    return (widget.curso['titulo'] ?? 'Curso').toString();
  }

  bool get _isProfessorOuAdmin {
    return _userTipo == 'professor' || _userTipo == 'admin';
  }

  bool get _isAdmin {
    return _userTipo == 'admin';
  }

  @override
  void initState() {
    super.initState();
    _carregarMaterias();
  }

  Future<void> _carregarMaterias() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final tipo = prefs.getString('userTipo') ?? 'aluno';
      final materias = await ApiService.getMaterias(_cursoId);

      if (!mounted) return;

      setState(() {
        _userTipo = tipo;
        _materias = materias;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar matérias.';
        _materias = [];
        _carregando = false;
      });
    }
  }

  Widget _campo(
    TextEditingController controller,
    String hint, {
    int linhas = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: linhas,
        keyboardType: keyboardType,
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

  Future<void> _salvarMateria({
    int? id,
    required String titulo,
    required String conteudo,
    required int ordem,
  }) async {
    if (titulo.trim().isEmpty) return;

    if (mounted) {
      setState(() {
        _salvando = true;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final professorId = int.tryParse(prefs.getString('userId') ?? '0') ?? 0;

      final dados = {
        'cursoId': _cursoId,
        'professorId': professorId,
        'titulo': titulo.trim(),
        'conteudo': conteudo.trim(),
        'ordem': ordem,
      };

      if (id == null) {
        await ApiService.createMateria(dados);
      } else {
        await ApiService.updateMateria(id, dados);
      }

      await _carregarMaterias();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(id == null ? 'Matéria criada!' : 'Matéria atualizada!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar matéria: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _abrirFormularioMateria({Map<String, dynamic>? materia}) {
    final tituloCtrl = TextEditingController(
      text: materia?['titulo']?.toString() ?? '',
    );

    final conteudoCtrl = TextEditingController(
      text: materia?['conteudo']?.toString() ?? '',
    );

    final ordemCtrl = TextEditingController(
      text: materia?['ordem']?.toString() ?? '${_materias.length + 1}',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.72,
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
              Text(
                materia == null ? 'Criar Matéria' : 'Editar Matéria',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _campo(tituloCtrl, 'Título da matéria'),
              const SizedBox(height: 12),
              _campo(
                conteudoCtrl,
                'Conteúdo / descrição da matéria',
                linhas: 5,
              ),
              const SizedBox(height: 12),
              _campo(
                ordemCtrl,
                'Ordem',
                keyboardType: TextInputType.number,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _salvando
                      ? null
                      : () async {
                          final titulo = tituloCtrl.text.trim();
                          final conteudo = conteudoCtrl.text;
                          final ordem = int.tryParse(ordemCtrl.text.trim()) ??
                              (_materias.length + 1);

                          final materiaId = materia?['id'] is int
                              ? materia!['id'] as int
                              : int.tryParse(
                                  materia?['id']?.toString() ?? '',
                                );

                          if (titulo.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informe o título da matéria.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          Navigator.pop(sheetContext);

                          await _salvarMateria(
                            id: materiaId,
                            titulo: titulo,
                            conteudo: conteudo,
                            ordem: ordem,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    materia == null ? 'Criar Matéria' : 'Salvar Alterações',
                    style: const TextStyle(
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
      conteudoCtrl.dispose();
      ordemCtrl.dispose();
    });
  }

  Future<void> _deletarMateria(int id) async {
    if (!_isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Somente administradores podem excluir matérias.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
            'Deseja deletar esta matéria?',
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
      await ApiService.deleteMateria(id);
      await _carregarMaterias();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matéria removida.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar matéria: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _estadoCarregando() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _estadoErro() {
    return RefreshIndicator(
      onRefresh: _carregarMaterias,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 64,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _erro ?? 'Erro ao carregar matérias.',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _carregarMaterias,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoVazio() {
    return RefreshIndicator(
      onRefresh: _carregarMaterias,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          const Icon(
            Icons.menu_book_outlined,
            color: Colors.white30,
            size: 72,
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Nenhuma matéria cadastrada neste curso.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ),
          if (_isProfessorOuAdmin) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _abrirFormularioMateria(),
              icon: const Icon(Icons.add),
              label: const Text('Criar primeira matéria'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6CFF),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cardMateria(Map<String, dynamic> materia) {
    final id = materia['id'] is int
        ? materia['id'] as int
        : int.tryParse(materia['id']?.toString() ?? '') ?? 0;

    final titulo = materia['titulo']?.toString() ?? 'Sem título';
    final conteudo = materia['conteudo']?.toString() ?? '';
    final ordem = materia['ordem']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C3D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Na próxima etapa, esta matéria abrirá as tarefas.'),
              backgroundColor: Color(0xFF4A6CFF),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A6CFF),
                          Color(0xFF7B3FFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        ordem,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isProfessorOuAdmin)
                    PopupMenuButton<String>(
                      color: const Color(0xFF111C3D),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white70,
                      ),
                      onSelected: (value) {
                        if (value == 'editar') {
                          _abrirFormularioMateria(materia: materia);
                        }

                        if (value == 'deletar') {
                          _deletarMateria(id);
                        }
                      },
                      itemBuilder: (_) {
                        return [
                          const PopupMenuItem(
                            value: 'editar',
                            child: Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          if (_isAdmin)
                            const PopupMenuItem(
                              value: 'deletar',
                              child: Text(
                                'Deletar',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                        ];
                      },
                    ),
                ],
              ),
              if (conteudo.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  conteudo,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    color: Colors.white38,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Toque para ver tarefas em etapa futura',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listaMaterias() {
    return RefreshIndicator(
      onRefresh: _carregarMaterias,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _materias.length,
        itemBuilder: (_, index) {
          final materia = Map<String, dynamic>.from(_materias[index] as Map);
          return _cardMateria(materia);
        },
      ),
    );
  }

  Widget _body() {
    if (_carregando) {
      return _estadoCarregando();
    }

    if (_erro != null) {
      return _estadoErro();
    }

    if (_materias.isEmpty) {
      return _estadoVazio();
    }

    return _listaMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081225),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081225),
        elevation: 0,
        title: Text(
          _cursoTitulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isProfessorOuAdmin)
            IconButton(
              onPressed: () => _abrirFormularioMateria(),
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Criar Matéria',
            ),
        ],
      ),
      body: _body(),
    );
  }
}