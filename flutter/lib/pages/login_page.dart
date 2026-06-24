import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_page.dart';
import '../repositories/auth_repository.dart';

import '../screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _lembrarMe = false;
  bool _carregando = false;

  Future<void> _fazerLogin() async {
  final email = _emailController.text.trim();
  final senha = _senhaController.text.trim();

  if (email.isEmpty || senha.isEmpty) {
    _mostrarErro("Preencha todos os campos.");
    return;
  }

  setState(() => _carregando = true);

  try {
    final repository = AuthRepository();
    await repository.login(email, senha);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } catch (e) {
    _mostrarErro("Email ou senha incorretos.");
  } finally {
    setState(() => _carregando = false);
  }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        children: [

        
          Container(
            decoration: const BoxDecoration(color: Color(0xFF020817)),
          ),

        
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2563EB).withOpacity(0.30),
                    const Color(0xFF2563EB).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -180,
            right: -120,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C3AED).withOpacity(0.28),
                    const Color(0xFF7C3AED).withOpacity(0.07),
                    Colors.transparent,
                  ],
                ),
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
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 38),
                    ),

                    const SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "EmpowerLearn",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ".class",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2563EB),
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Aprenda. Execute. Evolua.",
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                    ),

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

                          Text(
                            "Bem-vindo de volta",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                  
                          Text("Email",
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "@gmail.com",
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xFF020817),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text("Senha",
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
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
                                child: Icon(
                                  _senhaVisivel
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white54,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF020817),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _lembrarMe = !_lembrarMe),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white24),
                                        shape: BoxShape.circle,
                                        color: _lembrarMe
                                            ? const Color(0xFF2563EB)
                                            : Colors.transparent,
                                      ),
                                      child: _lembrarMe
                                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text("Lembrar-me",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white54, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(
                                "Esqueci minha senha",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF2563EB), fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                    
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _carregando ? null : _fazerLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _carregando
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          "Entrar",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text("ou continue com",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white38, fontSize: 12)),
                              ),
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(child: socialButton("Google", Icons.g_mobiledata)),
                              const SizedBox(width: 12),
                              Expanded(child: socialButton("GitHub", Icons.code)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Não tem uma conta? ",
                            style: GoogleFonts.poppins(color: Colors.white54)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Text(
                            "Criar conta gratuita",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

Widget socialButton(String text, IconData icon) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
      color: const Color(0xFF020817),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(text,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}