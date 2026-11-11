import '../models/avaliacao.dart';
import '../models/nivel_risco.dart';
import 'regras_risco/regra_empresa_recente.dart';
import 'regras_risco/regra_nome_divergente.dart';
import 'regras_risco/regra_perguntas_golpe.dart';
import 'regras_risco/regra_risco.dart';
import 'regras_risco/regra_situacao_cadastral.dart';


class AvaliadorRisco {
  AvaliadorRisco(this.regras);

 
  factory AvaliadorRisco.padrao() {
    return AvaliadorRisco([
      RegraSituacaoCadastral(),
      RegraEmpresaRecente(),
      RegraNomeDivergente(),
      RegraPerguntasGolpe(),
    ]);
  }

  static const limiteMedio = 30;
  static const limiteAlto = 60;

  final List<RegraRisco> regras;

  ResultadoAvaliacao avaliar(ContextoAvaliacao contexto) {
    final sinais = regras.expand((regra) => regra.avaliar(contexto)).toList()
      ..sort((a, b) => b.pontos.compareTo(a.pontos));

    final pontuacao = sinais.fold<int>(0, (total, s) => total + s.pontos);

    return ResultadoAvaliacao(
      nivel: classificar(pontuacao),
      pontuacao: pontuacao,
      motivos: sinais.map((s) => s.motivo).toList(),
    );
  }

  static NivelRisco classificar(int pontuacao) {
    if (pontuacao >= limiteAlto) return NivelRisco.alto;
    if (pontuacao >= limiteMedio) return NivelRisco.medio;
    return NivelRisco.baixo;
  }
}
