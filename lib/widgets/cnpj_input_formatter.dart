import 'package:flutter/services.dart';

import '../regras/validador_cnpj.dart';


class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var limpo = ValidadorCnpj.limpar(newValue.text);
    if (limpo.length > 14) limpo = limpo.substring(0, 14);

    final buffer = StringBuffer();
    for (var i = 0; i < limpo.length; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(limpo[i]);
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
