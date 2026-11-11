import '../../models/avaliacao.dart';
import 'regra_risco.dart';

/// Empresa que não está ATIVA na Receita Federal não deveria cobrar nada.
class RegraSituacaoCadastral implements RegraRisco {
  static const pontos = 100;

  @override
  List<SinalRisco> avaliar(ContextoAvaliacao contexto) {
    final empresa = contexto.empresa;

    if (empresa == null || empresa.ativa) return const [];

    return [
      SinalRisco(
        pontos: pontos,
        motivo: 'A empresa está com situação "${empresa.situacao}" na '
            'Receita Federal. Ela não deveria estar cobrando nada.',
      ),
    ];
  }
}
