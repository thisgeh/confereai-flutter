import '../../models/avaliacao.dart';
import 'regra_risco.dart';

/// Golpistas costumam abrir empresas novas só para receber pagamentos.
class RegraEmpresaRecente implements RegraRisco {
  static const diasMuitoRecente = 180;
  static const diasRecente = 365;
  static const pontosMuitoRecente = 40;
  static const pontosRecente = 20;

  @override
  List<SinalRisco> avaliar(ContextoAvaliacao contexto) {
    final abertura = contexto.empresa?.dataInicioAtividade;
    if (abertura == null) return const [];

    final dias = contexto.dataReferencia.difference(abertura).inDays;

    if (dias < diasMuitoRecente) {
      return [
        SinalRisco(
          pontos: pontosMuitoRecente,
          motivo: 'A empresa foi aberta há apenas $dias dias. Golpistas '
              'costumam abrir empresas novas para receber pagamentos.',
        ),
      ];
    }

    if (dias < diasRecente) {
      return const [
        SinalRisco(
          pontos: pontosRecente,
          motivo: 'A empresa tem menos de 1 ano. Confira com mais cuidado.',
        ),
      ];
    }

    return const [];
  }
}
