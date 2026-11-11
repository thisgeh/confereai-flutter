
class Empresa {
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final String situacao;
  final DateTime? dataInicioAtividade;
  final String municipio;
  final String uf;
  final String atividadePrincipal;
  final String telefone;

  const Empresa({
    required this.cnpj,
    required this.razaoSocial,
    this.nomeFantasia = '',
    required this.situacao,
    this.dataInicioAtividade,
    this.municipio = '',
    this.uf = '',
    this.atividadePrincipal = '',
    this.telefone = '',
  });


  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      cnpj: _texto(json['cnpj']),
      razaoSocial: _texto(json['razao_social']),
      nomeFantasia: _texto(json['nome_fantasia']),
      situacao: _texto(json['descricao_situacao_cadastral'], 'DESCONHECIDA'),
      dataInicioAtividade:
          DateTime.tryParse(_texto(json['data_inicio_atividade'])),
      municipio: _texto(json['municipio']),
      uf: _texto(json['uf']),
      atividadePrincipal: _texto(json['cnae_fiscal_descricao']),
      telefone: _texto(json['ddd_telefone_1']),
    );
  }

 
  bool get ativa => situacao.trim().toUpperCase() == 'ATIVA';


  String get nomeExibicao =>
      nomeFantasia.trim().isNotEmpty ? nomeFantasia.trim() : razaoSocial.trim();

  String get cidade {
    if (municipio.isEmpty) return uf;
    if (uf.isEmpty) return municipio;
    return '$municipio - $uf';
  }

  static String _texto(dynamic valor, [String padrao = '']) {
    if (valor == null) return padrao;
    final texto = valor.toString().trim();
    return texto.isEmpty ? padrao : texto;
  }
}
