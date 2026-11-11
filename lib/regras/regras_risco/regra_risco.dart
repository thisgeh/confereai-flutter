import '../../models/avaliacao.dart';

/// Strategy: cada regra sabe identificar um tipo de sinal de golpe.
///
/// Para criar uma nova regra, basta implementar esta interface e
/// adicioná-la ao AvaliadorRisco, sem alterar as regras existentes.
abstract class RegraRisco {
  List<SinalRisco> avaliar(ContextoAvaliacao contexto);
}
