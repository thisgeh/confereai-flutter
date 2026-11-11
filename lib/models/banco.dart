
class Banco {
  final String ispb;
  final String nome;
  final String nomeCompleto;
  final int? codigo;

  const Banco({
    required this.ispb,
    required this.nome,
    required this.nomeCompleto,
    this.codigo,
  });

  factory Banco.fromJson(Map<String, dynamic> json) {
    final codigo = json['code'];

    return Banco(
      ispb: (json['ispb'] ?? '').toString(),
      nome: (json['name'] ?? '').toString().trim(),
      nomeCompleto: (json['fullName'] ?? json['name'] ?? '').toString().trim(),
      codigo: codigo is num ? codigo.toInt() : int.tryParse('${codigo ?? ''}'),
    );
  }


  String get codigoFormatado =>
      codigo == null ? '---' : codigo.toString().padLeft(3, '0');
}
