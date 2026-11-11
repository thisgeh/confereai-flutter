import '../../models/avaliacao.dart';
import '../texto_util.dart';
import 'regra_risco.dart';

/// Disseram que era uma empresa, mas o CNPJ é de outra.
class RegraNomeDivergente implements RegraRisco {
  static const pontos = 35;

  @override
  List<SinalRisco> avaliar(ContextoAvaliacao contexto) {
    final empresa = contexto.empresa;
    final nome = contexto.nomeInformado.trim();

    if (empresa == null || nome.isEmpty) return const [];

    final corresponde = TextoUtil.nomeCorresponde(
      nome,
      [empresa.razaoSocial, empresa.nomeFantasia],
    );

    if (corresponde) return const [];

    return [
      SinalRisco(
        pontos: pontos,
        motivo: 'Disseram que era "$nome", mas esse CNPJ é de '
            '"${empresa.nomeExibicao}".',
      ),
    ];
  }
}
