
class TextoUtil {
  TextoUtil._();

  static const _acentos = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c', 'ñ': 'n',
  };


  static const _palavrasIgnoradas = {
    'de', 'da', 'do', 'das', 'dos', 'e', 'a', 'o',
    'ltda', 'sa', 'me', 'epp', 'eireli', 'cia', 'companhia',
    'banco', 'bco', 'pagamento', 'pagamentos', 'servico', 'servicos',
    'financeira', 'credito', 'instituicao', 'empresa', 'comercio',
    'central', 'atendimento', 'loja',
  };


  static String normalizar(String texto) {
    final buffer = StringBuffer();

    for (final letra in texto.toLowerCase().split('')) {
      buffer.write(_acentos[letra] ?? letra);
    }

    return buffer
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }


  static List<String> palavrasRelevantes(String texto) {
    return normalizar(texto)
        .split(' ')
        .where((p) => p.length >= 2 && !_palavrasIgnoradas.contains(p))
        .toList();
  }

  static bool nomeCorresponde(String nome, List<String> nomesOficiais) {
    final palavras = palavrasRelevantes(nome);
    if (palavras.isEmpty) return true;

    final oficiais = nomesOficiais.map(normalizar).join(' ');
    final oficiaisSemEspaco = oficiais.replaceAll(' ', '');

    return palavras.any(
      (p) => oficiais.split(' ').contains(p) || oficiaisSemEspaco.contains(p),
    );
  }
}
