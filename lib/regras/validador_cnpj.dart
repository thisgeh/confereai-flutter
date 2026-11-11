
class ValidadorCnpj {
  ValidadorCnpj._();

  static const _pesosPrimeiroDigito = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static const _pesosSegundoDigito = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];


  static String limpar(String valor) {
    return valor.toUpperCase().replaceAll(RegExp(r'[^0-9A-Z]'), '');
  }

  static bool valido(String valor) {
    final cnpj = limpar(valor);

    if (!RegExp(r'^[0-9A-Z]{12}[0-9]{2}$').hasMatch(cnpj)) return false;

    
    if (RegExp(r'^(.)\1{13}$').hasMatch(cnpj)) return false;

    final primeiro = _calcularDigito(cnpj.substring(0, 12), _pesosPrimeiroDigito);
    final segundo = _calcularDigito(cnpj.substring(0, 13), _pesosSegundoDigito);

    return cnpj[12] == '$primeiro' && cnpj[13] == '$segundo';
  }


  static String formatar(String valor) {
    final cnpj = limpar(valor);
    if (cnpj.length != 14) return valor;

    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.'
        '${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-'
        '${cnpj.substring(12)}';
  }

  static int _calcularDigito(String base, List<int> pesos) {
    var soma = 0;

    for (var i = 0; i < base.length; i++) {

      final valor = base.codeUnitAt(i) - 48;
      soma += valor * pesos[i];
    }

    final resto = soma % 11;
    return resto < 2 ? 0 : 11 - resto;
  }
}
