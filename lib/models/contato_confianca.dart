
class ContatoConfianca {
  final String id;
  final String nome;
  final String telefone;

  const ContatoConfianca({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  String get inicial => nome.trim().isEmpty ? '?' : nome.trim()[0].toUpperCase();

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
      };

  factory ContatoConfianca.fromJson(Map<String, dynamic> json) {
    return ContatoConfianca(
      id: json['id'] as String,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
    );
  }
}
