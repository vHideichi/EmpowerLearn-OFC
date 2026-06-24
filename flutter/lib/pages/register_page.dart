import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/auth_repository.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _carregando = false;
  String _tipoSelecionado = 'aluno';

  final List<Map<String, String>> _tipos = [
    {'value': 'aluno', 'label': 'Aluno'},
    {'value': 'professor', 'label': 'Professor'},
    {'value': 'admin', 'label': 'Instituição'},
  ];

  Future<void> _criarConta() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _mostrarErro("Preencha todos os campos.");
      return;
    }

    if (senha.length < 6) {
      _mostrarErro("A senha deve ter pelo menos 6 caracteres.");
      return;
    }

    setState(() => _carregando = true);

    try {
      final repository = AuthRepository();
      await repository.register(nome, email, senha, _tipoSelecionado);

      if (!mounted) return;
      _mostrarSucesso("Conta criada com sucesso! Faça o login.");

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      _mostrarErro("Erro ao criar conta: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1A),
      body: Stack(
        children: [
          Positioned(
            top: -120, left: -120,
            child: Container(
              width: 320, height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFF2563EB).withOpacity(0.18), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: -150, right: -120,
            child: Container(
              width: 350, height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFF7C3AED).withOpacity(0.18), Colors.transparent]),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 38),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "EmpowerLearn", style: GoogleFonts.poppins(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                        TextSpan(text: ".class", style: GoogleFonts.poppins(color: const Color(0xFF2563EB), fontSize: 34, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Text("Aprenda. Execute. Evolua.", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 40),
                    Container(
                      width: 400,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Criar conta gratuita", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30),

                          // NOME
                          Text("Nome", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nomeController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Seu nome completo",
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.white54),
                              filled: true, fillColor: const Color(0xFF020817),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // TIPO
                          Text("Tipo de conta", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF020817),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButton<String>(
                              value: _tipoSelecionado,
                              isExpanded: true,
                              dropdownColor: const Color(0xFF0F172A),
                              underline: const SizedBox(),
                              style: const TextStyle(color: Colors.white),
                              items: _tipos.map((tipo) {
                                return DropdownMenuItem<String>(
                                  value: tipo['value'],
                                  child: Text(tipo['label']!, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _tipoSelecionado = value!);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // EMAIL
                          Text("Email", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "@gmail.com",
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                              filled: true, fillColor: const Color(0xFF020817),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // SENHA
                          Text("Senha", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _senhaController,
                            obscureText: !_senhaVisivel,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() => _senhaVisivel = !_senhaVisivel),
                                child: Icon(_senhaVisivel ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white54),
                              ),
                              filled: true, fillColor: const Color(0xFF020817),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // BOTÃO
                          SizedBox(
                            width: double.infinity, height: 55,
                            child: ElevatedButton(
                              onPressed: _carregando ? null : _criarConta,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _carregando
                                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                      : Text("Criar conta", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Já tem uma conta? ", style: GoogleFonts.poppins(color: Colors.white54)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text("Entrar", style: GoogleFonts.poppins(color: const Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}