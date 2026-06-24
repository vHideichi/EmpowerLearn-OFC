import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<dynamic> _posts = [];
  bool _carregando = true;
  bool _publicando = false;
  String _nomeUsuario = 'Usuário';
  String? _erro;

  @override
  void initState() {
    super.initState();
    _iniciarTela();
  }

  Future<void> _iniciarTela() async {
    await Future.wait([
      _carregarNome(),
      _carregarPosts(),
    ]);
  }

  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final nomeSalvo = prefs.getString('userNome') ?? 'Usuário';

    setState(() {
      _nomeUsuario = nomeSalvo.isNotEmpty ? nomeSalvo : 'Usuário';
    });
  }

  Future<void> _carregarPosts() async {
    if (!mounted) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final posts = await ApiService.getForumPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _posts = [];
        _carregando = false;
        _erro = 'Erro ao carregar discussões.';
      });
    }
  }

  String _textoSeguro(dynamic valor, {String fallback = ''}) {
    if (valor == null) return fallback;
    return valor.toString();
  }

  String _tituloPost(dynamic post) {
    if (post is! Map) return 'Discussão';

    final titulo = post['titulo'];
    final conteudo = post['conteudo'];

    if (titulo != null && titulo.toString().trim().isNotEmpty) {
      return titulo.toString();
    }

    if (conteudo != null && conteudo.toString().trim().isNotEmpty) {
      final texto = conteudo.toString().trim();
      return texto.length > 40 ? '${texto.substring(0, 40)}...' : texto;
    }

    return 'Discussão';
  }

  String _conteudoPost(dynamic post) {
    if (post is! Map) return '';
    return _textoSeguro(post['conteudo']);
  }

  String _nomeAutor(dynamic post) {
    if (post is! Map) return _nomeUsuario;

    final autor = post['autor'] ?? post['usuario'] ?? post['user'];

    if (autor is Map && autor['nome'] != null) {
      return autor['nome'].toString();
    }

    if (post['autorNome'] != null) {
      return post['autorNome'].toString();
    }

    return _nomeUsuario;
  }

  String _inicialAutor(String nome) {
    final nomeLimpo = nome.trim();
    if (nomeLimpo.isEmpty) return 'U';
    return nomeLimpo[0].toUpperCase();
  }

  Future<void> _publicarPost(String conteudo) async {
    if (conteudo.trim().isEmpty) return;

    if (!mounted) return;

    setState(() {
      _publicando = true;
    });

    try {
      await ApiService.createForumPost(conteudo.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Discussão publicada!'),
          backgroundColor: Colors.green,
        ),
      );

      await _carregarPosts();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao publicar discussão: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _publicando = false;
        });
      }
    }
  }

  void _criarPost() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
                      'Criar Nova Discussão',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compartilhe dúvidas, experiências e conhecimentos com outros alunos.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: controller,
                        maxLines: 8,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'O que você gostaria de compartilhar hoje?',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        icon: _publicando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          _publicando ? 'Publicando...' : 'Publicar Discussão',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _publicando
                            ? null
                            : () async {
                                final texto = controller.text.trim();

                                if (texto.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Digite uma mensagem antes de publicar.'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                Navigator.pop(sheetContext);
                                await _publicarPost(texto);
                              },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      controller.dispose();
    });
  }

  Widget _buildEstadoVazio() {
    return RefreshIndicator(
      onRefresh: _carregarPosts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(
            child: Text(
              'Nenhuma discussão ainda.',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErro() {
    return RefreshIndicator(
      onRefresh: _carregarPosts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 160),
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 42,
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _erro ?? 'Erro ao carregar discussões.',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: _carregarPosts,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaPosts() {
    return RefreshIndicator(
      onRefresh: _carregarPosts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _posts.length,
        itemBuilder: (_, index) {
          final post = _posts[index];
          final autor = _nomeAutor(post);
          final titulo = _tituloPost(post);
          final conteudo = _conteudoPost(post);

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111C3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.blue,
                      child: Text(
                        _inicialAutor(autor),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (autor.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    autor,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  conteudo,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget conteudo;

    if (_carregando) {
      conteudo = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_erro != null) {
      conteudo = _buildErro();
    } else if (_posts.isEmpty) {
      conteudo = _buildEstadoVazio();
    } else {
      conteudo = _buildListaPosts();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _criarPost,
        backgroundColor: AppColors.blue,
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: const Text(
          'Nova Discussão',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Discussões',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: conteudo),
          ],
        ),
      ),
    );
  }
}