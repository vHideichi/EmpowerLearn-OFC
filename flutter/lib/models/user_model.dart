
class UserModel {
  final int id;
  final String nome;
  final String email;
  final String tipo;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipo: json['tipo'],
    );
  }
}