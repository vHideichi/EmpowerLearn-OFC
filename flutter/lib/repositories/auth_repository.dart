import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  Future<UserModel> login(String email, String senha) async {
    final data = await ApiService.login(email, senha);

    final user = UserModel.fromJson(data['usuario']);
    final token = data['token'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', user.id.toString());
    await prefs.setString('userTipo', user.tipo);
    await prefs.setString('userNome', user.nome);
    await prefs.setString('userEmail', user.email);

    return user;
  }

  Future<void> register(String nome, String email, String senha, String tipo) async {
    await ApiService.register({
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
    });
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}