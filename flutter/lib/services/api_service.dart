import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://empowerlearn-ofc-production.up.railway.app';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return int.tryParse(prefs.getString('userId') ?? '0') ?? 0;
  }

  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Email ou senha inválidos');
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );
    if (response.statusCode == 201) return jsonDecode(response.body);
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Erro no cadastro');
  }

  static Future<List<dynamic>> getCursos() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/cursos'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<Map<String, dynamic>> getCursoById(int id) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/cursos/$id'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Curso não encontrado');
  }

  static Future<void> createCurso(Map<String, dynamic> dados) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/cursos'),
      headers: headers,
      body: jsonEncode({...dados, 'criadorId': userId}),
    );
  }

  static Future<void> updateCurso(int id, Map<String, dynamic> dados) async {
    final headers = await _headers();
    await http.put(Uri.parse('$baseUrl/cursos/$id'), headers: headers, body: jsonEncode(dados));
  }

  static Future<void> deleteCurso(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/cursos/$id'), headers: headers);
  }

  static Future<List<dynamic>> getMaterias(int cursoId) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/materias?cursoId=$cursoId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<Map<String, dynamic>> getMateriaById(int id) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/materias/$id'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Matéria não encontrada');
  }

  static Future<void> createMateria(Map<String, dynamic> dados) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/materias'),
      headers: headers,
      body: jsonEncode({...dados, 'professorId': userId}),
    );
  }

  static Future<void> updateMateria(int id, Map<String, dynamic> dados) async {
    final headers = await _headers();
    await http.put(Uri.parse('$baseUrl/materias/$id'), headers: headers, body: jsonEncode(dados));
  }

  static Future<void> deleteMateria(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/materias/$id'), headers: headers);
  }

  static Future<List<dynamic>> getMinhasMatriculas() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/matriculas'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> matricular(int cursoId) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/matriculas'),
      headers: headers,
      body: jsonEncode({'alunoId': userId, 'cursoId': cursoId}),
    );
  }

  static Future<void> cancelarMatricula(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/matriculas/$id'), headers: headers);
  }

  static Future<List<dynamic>> getTarefas(int materiaId) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/tarefas?materiaId=$materiaId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> createTarefa(Map<String, dynamic> dados) async {
    final headers = await _headers();
    await http.post(Uri.parse('$baseUrl/tarefas'), headers: headers, body: jsonEncode(dados));
  }

  static Future<void> updateTarefa(int id, Map<String, dynamic> dados) async {
    final headers = await _headers();
    await http.put(Uri.parse('$baseUrl/tarefas/$id'), headers: headers, body: jsonEncode(dados));
  }

  static Future<void> deleteTarefa(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/tarefas/$id'), headers: headers);
  }

  static Future<List<dynamic>> getSubmissoes(int tarefaId) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/submissoes?tarefaId=$tarefaId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> submeterTarefa(int tarefaId, String resposta) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/submissoes'),
      headers: headers,
      body: jsonEncode({'tarefaId': tarefaId, 'alunoId': userId, 'resposta': resposta}),
    );
  }

  static Future<void> corrigirSubmissao(int id, double nota, String feedback) async {
    final headers = await _headers();
    await http.put(
      Uri.parse('$baseUrl/submissoes/$id'),
      headers: headers,
      body: jsonEncode({'nota': nota, 'feedback': feedback}),
    );
  }

  static Future<List<dynamic>> getForumPosts({int? cursoId}) async {
    final headers = await _headers();
    final url = cursoId != null ? '$baseUrl/forum?cursoId=$cursoId' : '$baseUrl/forum';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> createForumPost(String conteudo, {int? cursoId}) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/forum'),
      headers: headers,
      body: jsonEncode({
        'conteudo': conteudo,
        'titulo': conteudo.length > 50 ? conteudo.substring(0, 50) : conteudo,
        'usuarioId': userId,
        if (cursoId != null) 'cursoId': cursoId,
      }),
    );
  }

  static Future<void> deleteForumPost(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/forum/$id'), headers: headers);
  }

  static Future<List<dynamic>> getComentarios(int postId) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/comentarios?postId=$postId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> createComentario(int postId, String conteudo) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/comentarios'),
      headers: headers,
      body: jsonEncode({'postId': postId, 'autorId': userId, 'conteudo': conteudo}),
    );
  }

  static Future<void> deleteComentario(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/comentarios/$id'), headers: headers);
  }

  static Future<List<dynamic>> getNotificacoes() async {
    final headers = await _headers();
    final userId = await _getUserId();
    final response = await http.get(Uri.parse('$baseUrl/notificacoes?usuarioId=$userId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> marcarNotificacaoLida(int id) async {
    final headers = await _headers();
    await http.put(Uri.parse('$baseUrl/notificacoes/$id'), headers: headers, body: jsonEncode({'lida': true}));
  }

  static Future<List<dynamic>> getVideos(int materiaId) async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/videos?materiaId=$materiaId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> createVideo(Map<String, dynamic> dados) async {
    final headers = await _headers();
    await http.post(Uri.parse('$baseUrl/videos'), headers: headers, body: jsonEncode(dados));
  }

  static Future<List<dynamic>> getMeuProgresso() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/progresso-materias'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> concluirMateria(int materiaId) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/progresso-materias'),
      headers: headers,
      body: jsonEncode({'alunoId': userId, 'materiaId': materiaId}),
    );
  }

  static Future<List<dynamic>> getMeusFavoritos() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/favoritos'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> favoritarCurso(int cursoId) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/favoritos'),
      headers: headers,
      body: jsonEncode({'alunoId': userId, 'tipo': 'curso', 'refId': cursoId}),
    );
  }

  static Future<void> removerFavorito(int id) async {
    final headers = await _headers();
    await http.delete(Uri.parse('$baseUrl/favoritos/$id'), headers: headers);
  }

  static Future<List<dynamic>> getMinhasNotas() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/notas-aluno'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<void> createNota(Map<String, dynamic> dados) async {
    final headers = await _headers();
    final userId = await _getUserId();
    await http.post(
      Uri.parse('$baseUrl/notas-aluno'),
      headers: headers,
      body: jsonEncode({...dados, 'alunoId': userId}),
    );
  }

  static Future<List<dynamic>> getMeuHistorico() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse('$baseUrl/historico'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future<Map<String, dynamic>> getMeuPerfil() async {
    final headers = await _headers();
    final userId = await _getUserId();
    final response = await http.get(Uri.parse('$baseUrl/usuarios/$userId'), headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Erro ao carregar perfil');
  }
}