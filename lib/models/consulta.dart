import 'avaliacao.dart';
import 'nivel_risco.dart';

enum TipoConsulta { empresa, golpe }


class Consulta {
  final String id;
  final TipoConsulta tipo;
  final String titulo;
  final String documento;
  final NivelRisco nivel;
  final int pontuacao;
  final List<String> motivos;
  final DateTime data;
  final bool confiavel;

  const Consulta({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.documento = '',
    required this.nivel,
    required this.pontuacao,
    this.motivos = const [],
    required this.data,
    this.confiavel = false,
  });


  factory Consulta.criar({
    required ContextoAvaliacao contexto,
    required ResultadoAvaliacao resultado,
  }) {
    final empresa = contexto.empresa;

    return Consulta(
      id: contexto.dataReferencia.microsecondsSinceEpoch.toString(),
      tipo: empresa == null ? TipoConsulta.golpe : TipoConsulta.empresa,
      titulo: empresa?.nomeExibicao ?? 'Teste do golpe',
      documento: empresa?.cnpj ?? '',
      nivel: resultado.nivel,
      pontuacao: resultado.pontuacao,
      motivos: resultado.motivos,
      data: contexto.dataReferencia,
    );
  }

  Consulta copyWith({bool? confiavel}) {
    return Consulta(
      id: id,
      tipo: tipo,
      titulo: titulo,
      documento: documento,
      nivel: nivel,
      pontuacao: pontuacao,
      motivos: motivos,
      data: data,
      confiavel: confiavel ?? this.confiavel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'titulo': titulo,
      'documento': documento,
      'nivel': nivel.name,
      'pontuacao': pontuacao,
      'motivos': motivos,
      'data': data.toIso8601String(),
      'confiavel': confiavel,
    };
  }

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] as String,
      tipo: TipoConsulta.values.byName(json['tipo'] as String),
      titulo: json['titulo'] as String,
      documento: json['documento'] as String? ?? '',
      nivel: NivelRisco.values.byName(json['nivel'] as String),
      pontuacao: json['pontuacao'] as int,
      motivos: List<String>.from(json['motivos'] as List? ?? const []),
      data: DateTime.parse(json['data'] as String),
      confiavel: json['confiavel'] as bool? ?? false,
    );
  }
}
