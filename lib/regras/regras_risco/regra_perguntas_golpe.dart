import '../../models/avaliacao.dart';
import '../../models/pergunta_golpe.dart';
import 'regra_risco.dart';

/// Cada resposta "Sim" no teste do golpe gera um sinal de alerta.
class RegraPerguntasGolpe implements RegraRisco {
  RegraPerguntasGolpe([this.perguntas = PerguntasGolpe.todas]);

  final List<PerguntaGolpe> perguntas;

  @override
  List<SinalRisco> avaliar(ContextoAvaliacao contexto) {
    return perguntas
        .where((p) => contexto.respostasSim.contains(p.id))
        .map((p) => SinalRisco(pontos: p.pontos, motivo: p.motivo))
        .toList();
  }
}
