class UserModel {
  final int id;
  final String nome;
  final String email;
  final String tipo;
  final String? fotoUrl;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
    this.fotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nome: (json['nome'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      tipo: (json['tipo'] ?? 'aluno').toString(),
      fotoUrl: json['fotoUrl']?.toString(),
    );
  }
}