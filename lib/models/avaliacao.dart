import 'empresa.dart';
import 'nivel_risco.dart';


class ContextoAvaliacao {
  final Empresa? empresa;
  final String nomeInformado;
  final Set<String> respostasSim;
  final DateTime dataReferencia;

  ContextoAvaliacao({
    this.empresa,
    this.nomeInformado = '',
    this.respostasSim = const {},
    DateTime? dataReferencia,
  }) : dataReferencia = dataReferencia ?? DateTime.now();
}


class SinalRisco {
  final int pontos;
  final String motivo;

  const SinalRisco({
    required this.pontos,
    required this.motivo,
  });
}

/// Resultado final da avaliação.
class ResultadoAvaliacao {
  final NivelRisco nivel;
  final int pontuacao;
  final List<String> motivos;

  const ResultadoAvaliacao({
    required this.nivel,
    required this.pontuacao,
    required this.motivos,
  });
}
